class Sequencescape::Api::Version1
  def size_in_pages?
    false
  end
end

class Sequencescape::Api::Version2 < Sequencescape::Api::Version1
  def size_in_pages?
    true
  end
end

class Sequencescape::Api::Version3 < Sequencescape::Api::Version1

end