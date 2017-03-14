module Sequencescape::Api::Associations::HasMany::Validation
  def run_validations!
    # NOTE: Don't use all? here because it fails early and we need to see all validation errors
    all.inject(true) { |state, object| object.run_validations! and state }
  end

  def errors
    CompositeErrors.new(self)
  end

  class CompositeErrors
    def initialize(association)
      @association = association
    end

    def full_messages
      map_errors(&:full_messages).flatten
    end

    def empty?
      map_errors(&:empty?).all?
    end

    def clear
      map_errors(&:clear)
    end

    def [](field)
      map_errors { |errors| errors[field] }.flatten
    end

    def map_errors(&block)
      @association.map(&:errors)
        .map(&block)
    end
  end
end
