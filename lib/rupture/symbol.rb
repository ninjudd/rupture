require 'forwardable'

module Rupture
  class Symbol
    extend Forwardable
    def_delegators :@symbol, :to_s, :name, :namespace

    def initialize(*args)
      raise ArgumentError, "wrong number of arguments (#{args.size} for 2)" unless [1,2].include?(args.size)
      @symbol = args.join("/").to_sym
    end

    alias inspect to_s
  end
end
