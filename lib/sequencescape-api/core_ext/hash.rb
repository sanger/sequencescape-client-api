class Hash
  # Yields all of the missing keys if there are any so that you can do what you like, like
  # error maybe?
  def required!(*keys, &block)
    options = keys.extract_options!
    return if keys.empty?

    allowance_method = (options[:allow_blank] == false) ? :blank? : :nil?

    missing = keys.inject([]) do |missing, next_key|
      missing.tap do
        value = self[next_key]
        missing << next_key if value.send(allowance_method)
      end
    end
    yield(missing) unless missing.empty?
  end
end
