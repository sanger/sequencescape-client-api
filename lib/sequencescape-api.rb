require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/class/inheritable_attributes'
require 'active_support/core_ext/kernel/singleton_class'

module Sequencescape
  class Api
    Error = Class.new(StandardError)
  end
end

require 'sequencescape-api/core'
require 'sequencescape-api/resource'
require 'sequencescape-api/rails'
