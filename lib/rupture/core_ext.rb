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

class Object
  def map?
    false
  end

  def let(*vals)
    yield(self, *vals)
  end

  def fix(pred, f = nil, &fn)
    Rupture::Function.fix(self, pred, fn || f)
  end
end
