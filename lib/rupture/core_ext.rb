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

class Proc
  def complement
    lambda do |*args|
      not call(*args)
    end
  end

  def partial(*partials)
    lambda do |*args|
      call(*(partials + args))
    end
  end

  alias -@ complement
end

class Module
  def [](method_name)
    lambda do |*args|
      self.send(method_name, *args)
    end
  end
end

class Symbol
  def name
    parse_namespace unless @name
    @name
  end

  def namespace
    parse_namespace unless @name
    @namespace
  end

  def ~
    lambda do |object, *args|
      object.method(self)[*args]
    end
  end

private

  def parse_namespace
    @name, *ns = to_s.split('/').reverse
    @namespace = ns.join('/')
  end
end
