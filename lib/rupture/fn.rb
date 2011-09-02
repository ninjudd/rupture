module Rupture::Fn
  def self.identity
    lambda {|x| x}
  end

  def self.juxt(*fs)
    lambda do |*args|
      fs.collect {|f| f[*args]}
    end
  end

  def self.decorate(*args)
    juxt(identity, *args)
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

class Symbol
  def ~
    lambda do |object, *args|
      object.method(self)[*args]
    end
  end
end

class Module
  def [](method_name)
    lambda do |*args|
      self.send(method_name, *args)
    end
  end
end
