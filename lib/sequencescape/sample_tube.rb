require 'sequencescape/tube'

class Sequencescape::SampleTube < ::Sequencescape::Tube
  has_many   :requests
  has_many   :library_tubes
end
