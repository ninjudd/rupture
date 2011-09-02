module Rupture
  class Seq < Enumerable::Enumerator
    include Seqable

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
      # TODO: make efficient
      to_a == other.to_a
    end

    def conj(item)
      Cons.new(item, self)
    end

    def self.empty
      @empty ||= EmptySeq.new
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
