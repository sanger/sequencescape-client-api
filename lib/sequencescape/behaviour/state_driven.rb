module Sequencescape::Behaviour
  module StateDriven
    def self.included(base)
      base.class_eval do
        attribute_reader :state

        # Define a few default states
        [:pending, :started, :passed, :failed, :cancelled, :unknown, :qc_complete].each do |state|
          line = __LINE__ + 1
          class_eval(%Q{
            def #{state}?
              state == #{state.to_s.inspect}
            end
          }, __FILE__, line)
        end
      end
    end
  end
end
