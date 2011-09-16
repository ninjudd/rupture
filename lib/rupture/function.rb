module Rupture
  module Function
    # FIXME isn't totally lazy when working with > 1 collection
    # If the first is empty, the second is still seq'd
    def map(*colls, &f)
      f ||= colls.shift
      lazy_seq do
        seqs = colls.collect(&:seq)
        if seqs.all?
          firsts = seqs.collect(&:first)
          rests  = seqs.collect(&:rest)
          cons(f[*firsts], map(*rests, &f))
        end
      end
    end

    def concat(*colls)
      lazy_seq do
        head, *tail = colls.collect(&:seq)
        if head
          cons(head.first, concat(head.rest, *tail))
        elsif tail.any?
          concat(*tail)
        end
      end
    end

    def mapcat(*colls, &f)
      f ||= colls.shift
      concat(*map(*colls, &f))
    end

    def zip(*colls)
      lazy_seq do
        seqs = colls.collect(&:seq)
        if seqs.any?
          firsts = seqs.collect(&:first)
          rests  = seqs.collect(&:rest)
          cons(firsts, zip(*rests))
        end
      end
    end

    def filter(pred, coll)
      lazy_seq do
        if s = coll.seq
          e = s.first
          tail = filter(pred, s.rest)
          pred[e] ? cons(e, tail) : tail
        end
      end
    end

    def remove(pred, coll)
      filter(pred.complement, coll)
    end

    def loop(*vals)
      more  = true
      recur = lambda {|*vals| more = true}

      while more
        more = nil
        result = yield(recur, *vals)
      end
      result
    end

    def lazy_loop(*vals, &block)
      recur = lambda do |*v|
        lazy_seq {block[recur, *v]}
      end
      recur[*vals]
    end

    def iterate(*args, &f)
      f ||= args.shift
      Utils.verify_args(args, 1)
      x = args.first
      lazy_seq do
        cons(x, iterate(f[x], &f))
      end
    end

    def repeatedly(*args, &fn)
      fn ||= args.pop
      Utils.verify_args(args, 0, 1)
      n = args.first

      lazy_seq do
        if n.nil?
          cons(fn[], repeatedly(n, fn))
        elsif n > 0
          cons(fn[], repeatedly(n.dec, fn))
        end
      end
    end

    def repeat(*args)
      Utils.verify_args(args, 1, 2)
      x, n = args.reverse
      repeatedly(n) {x}
    end

    def lazy_seq(f = nil, &fn)
      fn ||= f
      LazySeq.new(&fn)
    end

    def cons(head, tail)
      Cons.new(head, tail)
    end

    def list(*xs)
      List.new(*xs)
    end

    def constantly(x)
      lambda {x}
    end

    def identity(x)
      x
    end

    def juxt(*fs)
      lambda do |*args|
        fs.collect {|f| f[*args]}
      end
    end

    def decorate(*args)
      juxt(identity, *args)
    end

    extend Function
    F = Function
  end
end
