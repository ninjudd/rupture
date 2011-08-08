if defined?(ActiveSupport::CoreExtensions::Hash::Keys)
  ActiveSupport::CoreExtensions::Hash::Keys.send(:define_method, :symbolize_keys!) do
    keys.each do |key|
      self[(key.to_sym rescue key) || key] = delete(key)
    end
    self
  end

  ActiveSupport::CoreExtensions::Hash::Keys.send(:define_method, :symbolize_keys) do
    dup.symbolize_keys!
  end

  ActiveSupport::CoreExtensions::Hash::Keys.send(:define_method, :stringify_keys) do
    keys.each do |key|
      self[key.to_s] = delete(key)
    end
    self
  end

  ActiveSupport::CoreExtensions::Hash::Keys.send(:define_method, :stringify_keys) do
    dup.stringify_keys!
  end
end
