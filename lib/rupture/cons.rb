module Rupture
  class Cons < Seq
    attr_reader :first

    def initialize(first, rest)
      @first, @rest = first, rest
      super()
    end

    def seq
      self
    end

    def rest
      @rest ||= Seq::Empty
    end
  end
end
