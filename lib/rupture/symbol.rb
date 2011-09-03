require 'forwardable'

class Rupture::Symbol # Use for symbols
  extend Forwardable
  def_delegators :@symbol, :to_s, :name, :namespace

  def initialize(*args)
    raise ArgumentError, "wrong number of arguments (#{args.size} for 2)" unless [1,2].include?(args.size)
    @symbol = args.join("/").to_sym
  end

  alias inspect to_s
end

class Symbol # Use for keywords
  def name
    parse_namespace unless @name
    @name
  end

  def namespace
    parse_namespace unless @name
    @namespace
  end

private

  def parse_namespace
    @name, *ns = to_s.split('/').reverse
    @namespace = ns.join('/')
  end
end
