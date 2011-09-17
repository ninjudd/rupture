class Hash
  def assoc!(*vals)
    vals.each_slice(2) do |k,v|
      self[k] = v
    end
    self
  end

  def update!(*args, &block)
    if args.size == 1
      key = args.shift
      self[key] = yield(self[key])
    else
      fn  = args.shift
      key = args.shift
      self[key] = fn.call(self[key], *args, &block)
    end
    self
  end

  def destruct(*keys)
    vals = keys.seq.map(self)
    block_given? ? yield(*vals) : vals
  end
end
