module Sequencescape::Behaviour
  module StateDriven
    def self.included(base) # rubocop:todo Metrics/MethodLength
      base.class_eval do
        attribute_reader :state

        # Define a few default states
        %i[pending started passed failed cancelled unknown qc_complete].each do |state|
          line = __LINE__ + 1
          class_eval("
            def #{state}?
              state == #{state.to_s.inspect}
            end
          ", __FILE__, line)
        end
      end
    end
  end
end
