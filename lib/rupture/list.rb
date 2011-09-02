module Rupture
  class List < Seq
    class << self
      alias create new
    end
    private_class_method :create
    attr_reader :seq # , :size

    def self.empty
      @empty ||= create(nil, 0)
    end

    def initialize(seq, size)
      @seq = seq.seq
      @size = size
    end

    def self.new(*args)
      list = self.empty
      args.reverse_each do |x|
        list = list.conj(x)
      end

      list
    end

    def conj(x)
      self.class.send(:create, Cons.new(x, @seq), @size.inc)
    end
  end
end
