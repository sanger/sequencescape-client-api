require 'uri'

class Sequencescape::Api::ConnectionFactory
  ConnectionError = Class.new(::Sequencescape::Api::Error)

  class_attribute :default_url

  def self.create(options)
    required_options = []
    required_options.push(:user_api_key) if options[:authorisation].blank?
    required_options.push(:url)    if default_url.blank?

    required_options.push(allow_blank: false)
    options.required!(*required_options) do |missing|
      raise ::Sequencescape::Api::Error, "No #{missing.or_sentence} set"
    end

    options[:url] ||= default_url
    new(options)
  end

  attr_reader :url, :user_api_key, :read_timeout
  private :url, :user_api_key, :read_timeout

  def initialize(options)
    @url = options[:url]
    @user_api_key = options[:user_api_key]
    @authorisation = options[:authorisation]
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
