module Sequencescape::Behaviour
  module Qced
    module QcFile
      def create!(attributes = nil)
        attributes ||= {}

        new({}, false).tap do |qc_file|
          api.create(actions.create, { 'qc_file' => attributes }, Sequencescape::Api::ModifyingHandler.new(qc_file))
        end
      end

      def create_from_file!(file, filename)
        attributes ||= {}

        new({}, false).tap do |qc_file|
          api.create_from_file(actions.create, file, filename, 'sequencescape/qc_file', Sequencescape::Api::ModifyingHandler.new(qc_file))
        end
      end
    end

    def self.included(base)
      base.class_eval do
        has_many :qc_files do
          include Sequencescape::Behaviour::Qced::QcFile
        end
      end
    end
  end
end
