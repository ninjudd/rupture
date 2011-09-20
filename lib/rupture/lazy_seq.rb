module Rupture
  class LazySeq < Seq
    def initialize(block = nil)
      @block = block
    end

    def seq
      return @seq unless @block
      @seq   = @block.call.seq
      @block = nil
      @seq
    end
  end
end

module Enumerable
  def seq
    F.lazy_seq do
      callcc do |external|
        each do |item|
          external = callcc do |internal|
            rest = F.lazy_seq do
              callcc do |external|
                internal.call(external)
              end
            end
            external.call(F.cons(item, rest))
          end
        end
        external.call(nil)
      end
    end
  end
end
