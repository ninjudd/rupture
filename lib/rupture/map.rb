module Rupture
  module Map
    def map?
      true
    end

    def associate(*kvs)
      into(kvs.seq.partition(2))
    end

    def assoc(*kvs)
      associate(*kvs)
    end

    def into(other)
      other.seq.reduce(as_map) do |map, (k,v)|
        map.put(k,v)
      end
    end

    def update(key, fn = nil, *args, &block)
      if fn
        assoc(key, fn.call(self[key], *args, &block))
      else
        assoc(key, yield(self[key]))
      end
    end

    def update_each(keys, *args, &block)
      map = as_map
      keys.each do |key|
        update(key, *args, &block)
      end
      map
    end

    def destruct(*keys)
      vals = keys.seq.map(self)
      block_given? ? yield(*vals) : vals
    end
  end
end
