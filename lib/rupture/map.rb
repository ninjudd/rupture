class Hash
  def map?
    true
  end

  def assoc!(*vals)
    vals.each_slice(2) do |k,v|
      self[k] = v
    end
    self
  end

  def update!(key, fn = nil, *args, &block)
    self[key] = if fn
      fn.call(self[key], *args, &block)
    else
      yield(self[key])
    end
    self
  end

  def update_each!(keys, *args, &block)
    keys.each do |key|
      update!(key, *args, &block)
    end
    self
  end

  def destruct(*keys)
    vals = keys.seq.map(self)
    block_given? ? yield(*vals) : vals
  end
end
