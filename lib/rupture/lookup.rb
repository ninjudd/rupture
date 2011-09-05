module Rupture
  module Lookup
    def lookup
      lambda do |a|
        a[self]
      end
    end
  end
end

class Symbol
  include Rupture::Lookup

  alias ~ lookup
end

class String
  include Rupture::Lookup
end

class Numeric
  include Rupture::Lookup
end

