module Rupture
  module Sequence
    def first
      seq.first
    end

    def rest
      seq.rest
    end

    def next
      rest.seq
    end

    def empty?
      not seq
    end

    def inspect
      "(#{to_a.collect(&:inspect).join(' ')})"
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

    def map(*colls, &block)
      Seq.map(self, *colls, &block)
    end

    def sequential?
      true
    end

    def flatten
      sequential = lambda {|x| x.class <= Seq or x.class == Array}
      tree_seq(sequential, ~:seq).remove(&sequential)
    end

    def concat(*colls, &block)
      Seq.concat(self, *colls, &block)
    end

    def mapcat(*colls, &block)
      Seq.mapcat(self, *colls, &block)
    end

    def tree_seq(branch, children)
      walk = lambda do |node|
        LazySeq.new do
          rest = children[node].mapcat(&walk) if branch[node]
          Cons.new(node, rest)
        end
      end
      walk[self]
    end

    def every?(&block)
      block ||= Fn.identity
      s = seq
      while s
        return false unless block[s.first]
        s = s.next
      end
      true
    end

    def some(&block)
      block ||= Fn.identity
      s = seq
      while s
        val = block[s.first]
        return val if val
        s = s.next
      end
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
  end
end
