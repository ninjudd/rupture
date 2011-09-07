require 'set'

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

    # def apply(*args)
    #   last = args.pop
    #   call(*F.concat(args, last))
    # end

    def to_proc
      lambda do |key|
        self[key]
      end
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

  def call(object = nil, *args)
    object.method(self)[*args]
  end
  alias [] call
end

class Hash
  include Rupture::Fn
  alias call []
end

class Array
  include Rupture::Fn
  alias call []
end

class Set
  include Rupture::Fn

  def [](key)
    key if include?(key)
  end
  alias call []
end

class Module
  def [](method_name, *partials)
    lambda do |*args|
      self.send(method_name, *(args + partials))
    end
  end
end
