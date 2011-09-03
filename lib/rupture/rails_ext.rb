class Hash
  def symbolize_keys!
    keys.each do |key|
      self[(key.to_sym rescue key) || key] = delete(key)
    end
    self
  end

  def symbolize_keys
    dup.symbolize_keys!
  end

  def deep_symbolize_keys!
    values.each do |val|
      val.deep_symbolize_keys! if val.is_a?(Hash)
    end
    symbolize_keys!
  end

  def deep_symbolize_keys
    copy = symbolize_keys
    copy.each do |key, val|
      copy[key] = val.deep_symbolize_keys if val.is_a?(Hash)
    end
    copy
  end

  def stringify_keys!
    keys.each do |key|
      self[key.to_s] = delete(key)
    end
    self
  end

  def stringify_keys
    dup.stringify_keys!
  end
end
