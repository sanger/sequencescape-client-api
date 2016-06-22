require 'uri'

class Sequencescape::Api::ConnectionFactory
  ConnectionError = Class.new(::Sequencescape::Api::Error)

  class_attribute :default_url

  def self.create(options)
    required_options = []
    required_options.push(:cookie) if options[:authorisation].blank?
    required_options.push(:url)    if self.default_url.blank?

    required_options.push(:allow_blank => false)
    options.required!(*required_options) do |missing|
      raise ::Sequencescape::Api::Error, "No #{missing.or_sentence} set"
    end

    options[:url] ||= self.default_url
    new(options)
  end

  attr_reader :url, :cookie, :read_timeout
  private :url, :cookie, :read_timeout

  def initialize(options)
    @url, @cookie, @authorisation = options[:url], options[:cookie], options[:authorisation]
    @read_timeout = options[:read_timeout] || 120
  end
  private_class_method :initialize

  def url_for_uuid(uuid)
    URI.join(url, uuid).to_s
  end

  require 'sequencescape-api/connection_factory/helpers'
  require 'sequencescape-api/connection_factory/actions'

  include Actions
end

