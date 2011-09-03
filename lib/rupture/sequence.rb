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
      R.cons(item, self)
    end

    def take(n)
      R.lazy_seq do
        if n.pos? and s = seq
          R.cons(s.first, s.rest.take(n.dec))
        end
      end
    end

    def drop(n)
      R.lazy_seq do
        s = seq
        while s and n.pos?
          n = n.dec
          s = s.next
        end
        s
      end
    end

    def take_while(f = nil, &fn)
      f ||= fn
      R.lazy_seq do
        if s = seq
          i = s.first
          R.cons(i, s.rest.take_while(&f)) if f[i]
        end
      end
    end

    def drop_while(f = nil, &fn)
      f ||= fn
      R.lazy_seq do
        s = seq
        while s and f[s.first]
          s = s.next
        end
        s
      end
    end

    def map(f = nil, &fn)
      f ||= fn
      R.map(self, &f)
    end

    def sequential?
      true
    end

    def flatten
      sequential = lambda {|x| x.class <= Seq or x.class == Array}
      tree_seq(sequential, ~:seq).remove(&sequential)
    end

    def concat(*colls)
      R.concat(self, *colls)
    end

    def mapcat(f = nil, &fn)
      f ||= fn
      R.mapcat(self, &f)
    end

    def tree_seq(branch, children, &f)
      branch   ||= f
      children ||= f
      walk = lambda do |node|
        R.lazy_seq do
          rest = children[node].mapcat(&walk) if branch[node]
          R.cons(node, rest)
        end
      end
      walk[self]
    end

    def every?(f = nil, &fn)
      f ||= fn || R[:identity]
      s = seq
      while s
        return false unless f[s.first]
        s = s.next
      end
      true
    end

    def some(f = nil, &fn)
      f ||= fn || R[:identity]
      s = seq
      while s
        val = f[s.first]
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

    def split_with(f = nil, &fn)
      f ||= fn
      [take_while(f), drop_while(f)]
    end

    def filter(f = nil, &fn)
      f ||= fn
      R.lazy_seq do
        if s = seq
          i = s.first
          tail = s.rest.filter(f)
          f[i] ? R.cons(i, tail) : tail
        end
      end
    end

    def remove(f = nil, &fn)
      f ||= fn
      filter(-f)
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
