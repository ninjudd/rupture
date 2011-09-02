module Rupture
  class ArraySeq < Seq
    def initialize(array, index = 0)
      @array = array
      @index = index
      super()
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
  end
end

class Array
  def seq
    Rupture::ArraySeq.new(self).seq
  end
end
