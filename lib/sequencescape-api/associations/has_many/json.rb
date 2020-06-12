module Sequencescape::Api::Associations::HasMany::Json
  def self.included(base)
    base.default_attributes_if_missing = []
  end

  def as_json(options = nil)
    options = { root: false, uuid: true }.reverse_merge(options || {})
    all.map { |o| o.as_json(options) }.compact
  end
end
