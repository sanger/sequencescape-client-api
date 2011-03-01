require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/class/inheritable_attributes'
require 'active_support/core_ext/kernel/singleton_class'
require 'active_support/core_ext/object/with_options'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/string/inflections'
require 'active_support/inflections'

require 'sequencescape-api/errors'
require 'sequencescape-api/core'
require 'sequencescape-api/resource'
require 'sequencescape-api/rails'

# Ensure that the I18n stuff has been properly configured
I18n.config.load_path << File.expand_path(File.join(File.dirname(__FILE__), %w{sequencescape-api locale en.yml}))
