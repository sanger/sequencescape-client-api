require 'net/http'
require 'multi_json'

# PINCHED FROM https://gist.github.com/736721
BEGIN {
  require 'net/http'

  Net::HTTP.module_eval do
    alias_method '__initialize__', 'initialize'

    def initialize(*args, &block)
      __initialize__(*args, &block)
    ensure
      @debug_output = $stderr if ENV['HTTP_DEBUG']
    end
  end
}

module Sequencescape::Api::ConnectionFactory::Actions
  ServerError = Class.new(Sequencescape::Api::ConnectionFactory::ConnectionError)

  def root(handler)
    read(url, handler)
  end

  def retrieve(url, handler, content_type)
    perform(:get, url, nil, content_type) do |response|
      case response
      when Net::HTTPSuccess      then response
      when Net::HTTPUnauthorized then handler.unauthenticated(parse_json_from(response))
      when Net::HTTPNotFound     then handler.missing(parse_json_from(response))
      when Net::HTTPRedirection  then handle_redirect(response, handler)
      else                            raise ServerError, response.body
      end
    end
  end

  def read(url, handler)
    perform(:get, url) do |response|
      case response
      when Net::HTTPSuccess      then handler.success(parse_json_from(response))
      when Net::HTTPUnauthorized then handler.unauthenticated(parse_json_from(response))
      when Net::HTTPNotFound     then handler.missing(parse_json_from(response))
      when Net::HTTPRedirection  then handle_redirect(response, handler)
      else                            raise ServerError, response.body
      end
    end
  end

  # rubocop:todo Metrics/MethodLength
  def create(url, body, handler)
    perform(:post, url, jsonify(body, action: :create)) do |response|
      case response
      when Net::HTTPCreated             then handler.success(parse_json_from(response))
      when Net::HTTPSuccess             then handler.success(parse_json_from(response)) # TODO: should be error!
      when Net::HTTPUnauthorized        then handler.unauthenticated(parse_json_from(response))
      when Net::HTTPUnprocessableEntity then handler.failure(parse_json_from(response))
      when Net::HTTPNotFound            then handler.missing(parse_json_from(response))
      when Net::HTTPRedirection         then handle_redirect(response, handler)
      else                                   raise ServerError, response.body
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:todo Metrics/MethodLength
  def create_from_file(url, file, filename, content_type, handler)
    perform_for_file(:post, url, file, filename, content_type) do |response|
      case response
      when Net::HTTPCreated             then handler.success(parse_json_from(response))
      when Net::HTTPSuccess             then handler.success(parse_json_from(response)) # TODO: should be error!
      when Net::HTTPUnauthorized        then handler.unauthenticated(parse_json_from(response))
      when Net::HTTPUnprocessableEntity then handler.failure(parse_json_from(response))
      when Net::HTTPNotFound            then handler.missing(parse_json_from(response))
      when Net::HTTPRedirection         then handle_redirect(response, handler)
      else                                   raise ServerError, response.body
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def update(url, body, handler)
    perform(:put, url, jsonify(body, action: :update)) do |response|
      case response
      when Net::HTTPSuccess             then handler.success(parse_json_from(response))
      when Net::HTTPUnauthorized        then handler.unauthenticated(parse_json_from(response))
      when Net::HTTPUnprocessableEntity then handler.failure(parse_json_from(response))
      when Net::HTTPNotFound            then handler.missing(parse_json_from(response))
      when Net::HTTPRedirection         then handle_redirect(response, handler)
      else                                   raise ServerError, response.body
      end
    end
  end

  def handle_redirect(response, handler)
    handler.redirection(parse_json_from(response)) do |read_handler|
      read(response['Location'], read_handler)
    end
  end
  private :handle_redirect

  def perform(http_verb, url, body = nil, accepts = nil) # rubocop:todo Metrics/MethodLength
    begin
      uri = URI.parse(url)
    rescue URI::InvalidURIError => e
      raise URI::InvalidURIError, "#{http_verb} failed: #{url.inspect} is not a valid uri"
    end
    Net::HTTP.start(uri.host, uri.port) do |connection|
      connection.read_timeout = read_timeout
      request_headers = headers
      request_headers.merge!('Accept' => accepts) unless accepts.nil?
      request = Net::HTTP.const_get(http_verb.to_s.classify).new(uri.request_uri, request_headers)
      unless body.nil?
        request.content_type = 'application/json'
        # request.body         = body.to_json
        request.body         = MultiJson.dump(body)
      end
      yield(connection.request(request))
    end
  end
  private :perform

  def perform_for_file(http_verb, url, file, filename, content_type)
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port) do |connection|
      connection.read_timeout = read_timeout
      file_headers = headers.merge!({ 'Content-Disposition' => "form-data; filename=\"#{filename}\"" })
      request = Net::HTTP.const_get(http_verb.to_s.classify).new(uri.request_uri, file_headers)
      request.content_type = content_type
      # request.body         = body.to_json
      request.body         = file.read
      yield(connection.request(request))
    end
  end
  private :perform

  def jsonify(body, options)
    case
    when body.nil?        then {}
    when body.is_a?(Hash) then body
    else                       body.as_json(options.merge(root: true))
    end
  end
  private :jsonify

  def parse_json_from(response)
    raise ServerError, 'server returned non-JSON content' unless response.content_type == 'application/json'

    MultiJson.load(StringIO.new(response.body))
  end
  private :parse_json_from

  def headers
    { 'Accept' => 'application/json', 'Cookie' => "api_key=#{user_api_key}" }.tap do |standard|
      standard.merge!('X-Sequencescape-Client-ID' => @authorisation) unless @authorisation.blank?
    end
  end
  private :headers
end
