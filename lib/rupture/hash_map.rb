require 'hamster'

module Rupture
  class HashMap < Hamster::Hash
    include Map

    def as_map
      self
    end

    def self.empty
      @empty ||= HashMap.new
    end
  end
end

class Hash
  include Rupture::Map

  def as_map
    F.hash_map(self)
  end
  alias ~ as_map

  def assoc!(*vals)
    vals.each_slice(2) do |k,v|
      self[k] = v
    end
    self
  end

  def update!(key, fn = nil, *args, &block)
    self[key] = if fn
      fn.call(self[key], *args, &block)
    else
      yield(self[key])
    end
    self
  end

  def update_each!(keys, *args, &block)
    keys.each do |key|
      update!(key, *args, &block)
    end
    self
  end
end
