require 'uri'
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

class Sequencescape::Api::ConnectionFactory
  ConnectionError = Class.new(::Sequencescape::Api::Error)
  ServerError     = Class.new(ConnectionError)

  module Helpers
    def connection_factory=(connection_factory)
      @connection_factory = connection_factory
    end

    def connection_factory
      @connection_factory ||= Sequencescape::Api::ConnectionFactory
    end
  end

  class_inheritable_accessor :default_url

  def self.create(options)
    required_options = [ :cookie ]
    required_options.push(:url) if self.default_url.blank?
    required_options.push(:allow_blank => false)
    options.required!(*required_options) do |missing|
      raise ::Sequencescape::Api::Error, "No #{missing.or_sentence} set"
    end

    options[:url] ||= self.default_url
    new(options)
  end

  attr_reader :url, :cookie
  private :url, :cookie

  def initialize(options)
    @url, @cookie, @authorisation = options[:url], options[:cookie], options[:authorisation]
  end
  private_class_method :initialize

  def url_for_uuid(uuid)
    URI.join(url, uuid).to_s
  end

  def root(&block)
    read(url, &block)
  end

  def read(url, &block)
    perform(:get, url) do |response|
      case response
      when Net::HTTPSuccess then yield(parse_json_from(response))
      else                       raise ServerError, response.body
      end
    end
  end

  def create(url, body = nil, &block)
    perform(:post, url, body || {}) do |response|
      case response
      when Net::HTTPCreated then yield(parse_json_from(response))
      when Net::HTTPSuccess then raise ServerError, 'server gave success but not created'
      else                       raise ServerError, response.body
      end
    end
  end

  def update(url, body = nil, &block)
    perform(:put, url, body || {}) do |response|
      case response
      when Net::HTTPSuccess then yield(parse_json_from(response))
      else                       raise ServerError, response.body
      end
    end
  end

  def perform(http_verb, url, body = nil, &block)
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port) do |connection|
      request              = Net::HTTP.const_get(http_verb.to_s.classify).new(uri.path, headers)
      unless body.nil?
        request.content_type = 'application/json'
        request.body         = body.to_json
      end
      yield(connection.request(request))
    end
  end
  private :perform

  def parse_json_from(response)
    Yajl::Parser.new.parse(StringIO.new(response.body))
  end
  private :parse_json_from

  def headers
    { 'Accept' => 'application/json', 'Cookie' => "WTSISignOn=#{cookie}" }.tap do |standard|
      standard.merge!('X-Sequencescape-Client-ID' => @authorisation) unless @authorisation.blank?
    end
  end
  private :headers
end

