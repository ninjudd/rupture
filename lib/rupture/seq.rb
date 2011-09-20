module Rupture
  class Seq
    include Enumerable
    include Sequence

    def inspect
      "(#{to_a.collect(&:inspect).join(',')})"
    end

    def [](index)
      nth(index)
    end

    def to_ary
      to_a
    end

    def eql?(other)
      return false unless other.respond_to?(:seq)

      s = self.seq
      o = other.seq
      while s && o
        return false if s.first != o.first
        s = s.next
        o = o.next
      end

      s.nil? and o.nil?
    end
    alias == eql?

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
  include Rupture::Sequence

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
