class Hash
  def assoc!(*vals)
    vals.each_slice(2) do |k,v|
      self[k] = v
    end
    self
  end

  def update!(*args, &block)
    key = args.shift

    if args.size == 0
      self[key] = yield(self[key])
    else
      fn = args.shift
      self[key] = fn.call(self[key], *args, &block)
    end
    self
  end

  def destruct(*keys)
    vals = keys.seq.map(self)
    block_given? ? yield(*vals) : vals
  end
end
