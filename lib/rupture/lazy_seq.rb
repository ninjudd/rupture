class Rupture::LazySeq < Rupture::Seq
  def initialize(&block)
    @block = block
    super()
  end

  def seq
    @seq ||= @block.call
  end
end
