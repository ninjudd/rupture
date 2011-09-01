class Rupture::Cons # < Rupture::Seq
  attr_reader :first, :rest
  def initialize(first, rest)
    @first, @rest = first, rest
    super()
  end

  def seq
    self
  end
end
