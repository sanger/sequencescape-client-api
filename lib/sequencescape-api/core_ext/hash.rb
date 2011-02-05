class Hash
  # Yields all of the missing keys if there are any so that you can do what you like, like
  # error maybe?
  def required!(key, *keys, &block)
    options          = keys.extract_options!
    allowance_method = (options[:allow_blank] == false) ? :blank? : :nil?

    missing = [ key, *keys ].inject([]) do |missing, next_key|
      missing.tap do 
        value = self[next_key]
        missing << value if value.send(allowance_method)
      end
    end
    yield(missing) unless missing.empty?
  end
end
