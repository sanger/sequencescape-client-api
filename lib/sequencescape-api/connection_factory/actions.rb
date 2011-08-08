require 'net/http'
require 'yajl'

# PINCHED FROM https://gist.github.com/736721
BEGIN {
  require 'net/http'
  
  Net::HTTP.module_eval do
    alias_method '__initialize__', 'initialize'
    
    def initialize(*args,&block)
      __initialize__(*args, &block)
    ensure
      @debug_output = $stderr if ENV['HTTP_DEBUG']
    end
  end
}

# Add a special exception class we need for invalid attributes being sent across from the client.
module Net
  class HTTPUnprocessableEntity < HTTPClientError
    HAS_BODY = true
  end

  class HTTPResponse
    CODE_TO_OBJ['422'] = HTTPUnprocessableEntity
  end
end

module Sequencescape::Api::ConnectionFactory::Actions
  ServerError = Class.new(Sequencescape::Api::ConnectionFactory::ConnectionError)

  def root(handler)
    read(url, handler)
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

  def create(url, body, handler)
    perform(:post, url, jsonify(body, :action => :create)) do |response|
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

  def update(url, body, handler)
    perform(:put, url, jsonify(body, :action => :update)) do |response|
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

  def perform(http_verb, url, body = nil, &block)
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port) do |connection|
      request = Net::HTTP.const_get(http_verb.to_s.classify).new(uri.request_uri, headers)
      unless body.nil?
        request.content_type = 'application/json'
        #request.body         = body.to_json
        request.body         = Yajl::Encoder.encode(body)
      end
      yield(connection.request(request))
    end
  end
  private :perform

  def jsonify(body, options)
    case
    when body.nil?        then {}
    when body.is_a?(Hash) then body
    else                       body.as_json(options.merge(:root => true))
    end
  end
  private :jsonify

  def parse_json_from(response)
    raise ServerError, 'server returned non-JSON content' unless response.content_type == 'application/json'
    Yajl::Parser.parse(StringIO.new(response.body))
  end
  private :parse_json_from

  def headers
    { 'Accept' => 'application/json', 'Cookie' => "WTSISignOn=#{cookie}" }.tap do |standard|
      standard.merge!('X-Sequencescape-Client-ID' => @authorisation) unless @authorisation.blank?
    end
  end
  private :headers
end
