class Sequencescape::User
  def initialize(owner, attributes)
    @owner, @attributes = owner, attributes
  end

  def login
    @attributes['login']
  end
end
