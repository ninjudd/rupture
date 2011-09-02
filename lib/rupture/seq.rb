module Rupture
  class Seq < Enumerable::Enumerator
    include Sequence
    alias conj cons

    def initialize
      super(self)
    end

    def each
      s = self
      while s = s.seq
        yield s.first
        s = s.rest
      end
    end

    def [](index)
      nth(index)
    end

    def ==(other)
      s = self.seq
      o = other.seq
      while s && o
        return false if s.first != o.first
        s = s.next
        o = o.next
      end
      s.nil? and o.nil?
    end

    def self.empty
      @empty ||= EmptySeq.new
    end

    # FIXME isn't totally lazy when working with > 1 collection
    # If the first is empty, the second is still seq'd
    def self.map(*colls, &block)
      LazySeq.new do
        seqs = colls.collect(&:seq)
        if seqs.all?
          firsts = seqs.collect(&:first)
          rests  = seqs.collect(&:rest)
          Cons.new(yield(*firsts), map(*rests, &block))
        end
      end
    end

    def self.concat(*colls)
      LazySeq.new do
        head, *tail = colls.collect(&:seq)
        if head
          Cons.new(head.first, concat(head.rest, *tail))
        elsif tail.any?
          concat(*tail)
        end
      end
    end

    def self.mapcat(*colls, &block)
      concat(*map(*colls, &block))
    end
  end

  class EmptySeq < Seq
    def seq
      nil
    end
  end
end

class NilClass
  def seq
    nil
  end

  def first
    nil
  end

  def rest
    Rupture::Seq.empty
  end
end
