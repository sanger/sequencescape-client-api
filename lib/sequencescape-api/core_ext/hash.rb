class Hash
  # Yields all of the missing keys if there are any so that you can do what you like, like
  # error maybe?
  def required!(key, *keys, &block)
    missing = ([ key, *keys ] - self.keys)
    yield(missing) unless missing.empty?
  end
end
