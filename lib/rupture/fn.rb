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
end

class Object
  def fn(name)
    block = instance_method(name)
    lambda do |object, *args|
      block.bind(object)[*args]
    end
  end

  def fnc(name)
    block = method(name)
    lambda do |object, *args|
      block.bind(object)[*args]
    end
  end
end
