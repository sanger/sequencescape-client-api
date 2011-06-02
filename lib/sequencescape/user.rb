class Sequencescape::User < ::Sequencescape::Api::Resource
  include Sequencescape::Api::Composition::Target

  attribute_accessor :login
  attribute_writer :swipecard_code
  attribute_reader :has_a_swipecard_code
end
