class Sequencescape::Comment < ::Sequencescape::Api::Resource
  belongs_to :plate

  attribute_accessor :content, :title

end
