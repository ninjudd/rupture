class Rupture::Seq < Enumerable::Enumerator
  include Seqable

private

  def initialize
    super(self, :_each)
  end

  def _each(&block)
    s = self
    while s = s.seq
      block.call(s.first)
      s = s.rest
    end
  end
end
