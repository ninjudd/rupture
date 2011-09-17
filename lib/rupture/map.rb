class Hash
  def assoc!(*vals)
    vals.each_slice(2) do |k,v|
      self[k] = v
    end
    self
  end

  def update!(*args, &block)
    key = args.shift
    val = self[key]

    self[key] = if args.size == 0
      yield(val)
    else
      args.shift.call(val, *args, &block)
    end

    self
  end

  def destruct(*keys)
    vals = keys.seq.map(self)
    block_given? ? yield(*vals) : vals
  end
end
