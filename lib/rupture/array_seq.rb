module Rupture
  class ArraySeq < Seq
    def initialize(array, index = 0)
      @array = array
      @index = index
    end

    def first
      @array[@index]
    end

    def rest
      ArraySeq.new(@array, @index.inc)
    end

    def seq
      self if @index < @array.size
    end

    def size
      @array.size - @index
    end
  end

  class RArraySeq < ArraySeq
    def initialize(array, index = array.size - 1)
      super(array, index)
    end

    def rest
      RArraySeq.new(@array, @index.dec)
    end

    def seq
      self if @index >= 0
    end

    def size
      @index.inc
    end
  end

  module ArraySeqable
    def seq
      Rupture::ArraySeq.new(self).seq
    end

    def rseq
      Rupture::RArraySeq.new(self).seq
    end

    def not_empty
      self if seq
    end
  end
end

class Array
  include Rupture::ArraySeqable
end

class String
  include Rupture::ArraySeqable
end
