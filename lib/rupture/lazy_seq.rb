module Rupture
  class LazySeq < Seq
    def initialize(&block)
      raise ArgumentError, "Block required" unless block
      @block = block
      super()
    end

    def seq
      return @seq unless @block
      @seq   = @block.call.seq
      @block = nil
      @seq
    end
  end
end
