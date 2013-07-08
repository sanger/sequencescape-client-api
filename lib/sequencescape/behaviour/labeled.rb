# Prefix depends on the submission template used and sumarises the order.
# Text at the moment is a bit redundant, being the purpose name. However
# it makes things much easier for cases where we are hashing our objects manually
module Sequencescape::Behaviour
  module Labeled
    def self.included(base)
      base.class_eval do
        attribute_group :label do
          attribute_accessor :prefix, :text
        end
      end
    end
  end
end
