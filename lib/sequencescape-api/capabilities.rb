class Sequencescape::Api::Version1
  def size_in_pages?
    false
  end
  
  def page_action
    :read
  end
end

class Sequencescape::Api::Version2 < Sequencescape::Api::Version1
  def size_in_pages?
    true
  end
end

class Sequencescape::Api::Version3 < Sequencescape::Api::Version2
  def page_action
      :first
    end
end