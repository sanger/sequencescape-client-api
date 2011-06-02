class Sequencescape::User < ::Sequencescape::Api::Resource
  attribute_accessor :login

  #TODO make swipecard_code readonly. Can't at the moment because of a bug
  #attribute_writer :swipecard_code
  attribute_accessor :swipecard_code

  attribute_reader :has_a_swipecard_code
end
