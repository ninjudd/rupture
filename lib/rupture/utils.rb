module Rupture
  module Utils
    def self.verify_args(args, *sizes)
      raise ArgumentError, "wrong number of arguments (#{args.size} for 2)" unless sizes.include?(args.size)
    end
  end
end
