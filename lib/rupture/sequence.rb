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

    def second
      rest.first
    end

    def empty?
      not seq
    end

    def not_empty
      self if seq
    end

    def divide
      [first, rest]
    end

    def each
      s = self
      while s = s.seq
        yield s.first
        s = s.rest
      end
    end

    def count
      F.loop(0, self) do |recur, i, s|
        if s.empty?
          i
        elsif s.respond_to?(:size)
          s.size + i
        else
          recur[i.inc, s.rest]
        end
      end
    end

    def conj(item)
      F.cons(item, self)
    end

    def into(coll)
      coll.seq.reduce(:conj, self)
    end

    def reverse
      Seq.empty.into(self)
    end

    def take(n)
      F.lazy_seq do
        if n.pos? and s = seq
          F.cons(s.first, s.rest.take(n.dec))
        end
      end
    end

    def drop(n)
      F.lazy_seq do
        F.loop(n, seq) do |recur, n, s|
          if s and n.pos?
            recur[n.dec, s.next]
          else
            s
          end
        end
      end
    end

    def take_last(n)
      F.loop(seq, drop(n).seq) do |recur, s, lead|
        if lead
          recur[s.next, lead.next]
        else
          s || Seq.empty
        end
      end
    end

    def drop_last(n)
      F.map(self, drop(n)) {|x,_| x}
    end

    def last
      take_last(1).first
    end

    def split_at(n)
      [take(n), drop(n)]
    end

    def take_while(p = nil, &pred)
      pred ||= p
      F.lazy_seq do
        if s = seq
          i = s.first
          F.cons(i, s.rest.take_while(pred)) if pred[i]
        end
      end
    end

    def drop_while(p = nil, &pred)
      pred ||= p
      F.lazy_seq do
        F.loop(seq) do |recur, s|
          if s and pred[s.first]
            recur[s.next]
          else
            s
          end
        end
      end
    end

    def split_with(p = nil, &pred)
      pred ||= p
      [take_while(pred), drop_while(pred)]
    end

    def filter(p = nil, &pred)
      pred ||= p
      F.filter(pred, self)
    end

    def remove(p = nil, &pred)
      pred ||= p
      F.remove(pred, self)
    end

    def separate(p = nil, &pred)
      pred ||= p
      [filter(pred), remove(pred)]
    end

    def sequential?
      true
    end

    def flatten
      sequential = lambda {|x| x.class <= Seq or x.class == Array}
      tree_seq(sequential, :seq).remove(sequential)
    end

    def map(f = nil, &fn)
      fn ||= f
      F.map(fn, self)
    end

    def map_indexed(f = nil, &fn)
      fn ||= f
      F.lazy_loop(0, seq) do |recur, i, s|
        F.cons(fn[i, s.first], recur[i.inc, s.next]) if s
      end
    end

    def concat(*colls)
      F.concat(self, *colls)
    end

    def mapcat(f = nil, &fn)
      fn ||= f
      F.mapcat(fn, self)
    end

    def reduce(*args, &fn)
      fn ||= args.shift
      Utils.verify_args(args, 0, 1)

      if s = seq
        inject(*args, &fn)
      elsif args.size == 1
        args.first
      else
        fn[] if fn.arity == -1
      end
    end

    def reductions(*args, &fn)
      fn ||= args.shift
      Utils.verify_args(args, 0, 1)
      acc, coll = (args.empty? ? divide : [args.first, self])

      F.lazy_loop(acc, coll) do |recur, acc, coll|
        if coll.seq
          acc = fn[acc, coll.first]
          F.cons(acc, recur[acc, coll.rest])
        end
      end.conj(acc)
    end

    def foldr(*args, &fn)
      fn ||= args.shift
      reverse.reduce(*args) {|a,b| fn[b,a]}
    end

    def tree_seq(branch, children, &f)
      branch   ||= f
      children ||= f
      walk = lambda do |node|
        F.lazy_seq do
          rest = children[node].mapcat(walk) if branch[node]
          F.cons(node, rest)
        end
      end
      walk[self]
    end

    def every?(p = nil, &pred)
      pred ||= p || F[:identity]
      all?(&pred)
    end

    def some(f = nil, &fn)
      fn ||= f || F[:identity]
      F.loop(seq) do |recur, s|
        if s
          if val = fn[s.first]
            val
          else
            recur[s.next]
          end
        end
      end
    end

    def nth(n)
      drop(n.dec).first
    end

    def partition(n, step = n, pad = nil)
      F.lazy_seq do
        if s = seq
          p = take(n)
          if n == p.count
            F.cons(p, drop(step).partition(n, step, pad))
          elsif pad
            F.cons(p.concat(pad).take(n), nil)
          else
            nil
          end
        end
      end
    end

    def partition_all(n, step = n)
      partition(n, step, [])
    end

    def partition_by(f = nil, &fn)
      fn ||= f
      F.lazy_seq do
        if s = seq
          head = s.first
          val  = fn[head]
          run = F.cons(head, s.rest.take_while {|i| val == fn[i]})
          F.cons(run, s.drop(run.count).partition_by(fn))
        end
      end
    end

    def partition_between(f = nil, &fn)
      fn ||= f
      F.lazy_seq do
        if s = seq
          run = F.cons(s.first, s.partition(2,1).take_while {|i| not fn[*i]}.map(:second))
          F.cons(run, s.drop(run.count).partition_between(fn))
        end
      end
    end

    def frequencies
      reduce({}) do |counts, x|
        counts.update!(:inc.fnil(0), x)
      end
    end

    def doall(n = nil)
      if n
        loop(n, seq) do |recur, n, s|
          recur[n.dec, s.next] if s and n.pos?
        end
      else
        loop(seq) do |recur, s|
          recur[s.next] if s
        end
      end
    end
  end
end
