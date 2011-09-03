module Rupture
  module Fn
    def complement
      lambda do |*args|
        not call(*args)
      end
    end
    alias -@ complement

    def partial(*partials)
      lambda do |*args|
        call(*(partials + args))
      end
    end

    def fn
      self
    end
  end
end

class Proc
  include Rupture::Fn
end

class Method
  include Rupture::Fn
end

class Symbol
  include Rupture::Fn

  def fn
    method(:call)
  end

  def call(object, *args)
    object.method(self)[*args]
  end

  def [](object, *args)
    if args.empty? and object.kind_of?(Hash)
      object[self]
    else
      call(object, *args)
    end
  end
end

class Module
  def [](method_name, *partials)
    lambda do |*args|
      self.send(method_name, *(args + partials))
    end
  end
end

class NilClass
  def fn
    nil
  end
end
