module Rupture
  module Seqable
    def first
      seq.first
    end

    def rest
      seq.rest
    end

    def next
      rest.seq
    end

    def inspect
      "(#{to_a.join(' ')})"
    end

    def cons(item)
      Cons.new(item, self)
    end

    def take(n)
      LazySeq.new do
        if n.pos? and s = seq
          Cons.new(s.first, s.rest.take(n.dec))
        end
      end
    end

    def drop(n)
      LazySeq.new do
        s = seq
        while s and n.pos?
          n = n.dec
          s = s.next
        end
        s
      end
    end

    def take_while(&block)
      LazySeq.new do
        if s = seq
          i = s.first
          Cons.new(i, s.rest.take_while(&block)) if yield(i)
        end
      end
    end

    def drop_while
      LazySeq.new do
        s = seq
        while s and yield(s.first)
          s = s.next
        end
        s
      end
    end

    def every?(&block)
      return true unless s = seq
      block ||= Fn.identity
      block.call(s.first) and s.rest.every?(&block)
    end

    def nth(n)
      drop(n.dec).first
    end

    def split_at(n)
      [take(n), drop(n)]
    end

    def split_with(&block)
      [take_while(&block), drop_while(&block)]
    end

    def filter(&block)
      LazySeq.new do
        if s = seq
          i = s.first
          tail = s.rest.filter(&block)
          yield(i) ? Cons.new(i, tail) : tail
        end
      end
    end

    def remove(&block)
      filter(&block.complement)
    end

    # alias filter   select
    # alias remove   reject
    # alias separate partition

    # def partition(n = nil, step = n, pad = nil, &block)
    #   return separate(&block) if n.nil?

    #   results = []
    #   coll = self

    #   while coll.size >= n
    #     results << coll.take(n)
    #     coll = coll.drop(step)
    #   end

    #   if pad and coll.any?
    #     results << coll + pad.take(n - coll.size)
    #   end
    #   results
    # end

    # def partition_all(n, step = n)
    #   partition(n, step, [])
    # end

    # def partition_all(n, step = n)
    #   partition(n, step, [])
    # end

    # def partition_by
    #   results  = []
    #   previous = nil

    #   each do |i|
    #     current = yield(i)
    #     results << [] if current != previous or results.empty?
    #     results.last << i
    #     previous = current
    #   end
    #   results
    # end

    # def partition_between
    #   return [] if empty?
    #   results = [[first]]

    #   partition(2, 1).each do |(a,b)|
    #     results << [] if yield(a,b)
    #     results.last << b
    #   end
    #   results
    # end

    # Remove methods in klass so they don't shadow Seqable.
    def self.included(klass)
      instance_methods.each do |method|
        klass.class_eval do
          remove_method method rescue nil
        end
      end
    end
  end
end
