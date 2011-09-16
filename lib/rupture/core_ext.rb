class Numeric
  def inc
    self + 1
  end

  def dec
    self - 1
  end

  def pos?
    self > 0
  end

  def neg?
    self < 0
  end

  def zero?
    self == 0
  end
end

class Hash
  def assoc!(*vals)
    vals.each_slice(2) do |k,v|
      self[k] = v
    end
    self
  end

  def update!(*args, &fn)
    fn ||= args.shift
    key = args.shift
    self[key] = fn[self[key], *args]
    self
  end
end
