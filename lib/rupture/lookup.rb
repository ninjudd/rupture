module Rupture
  module Lookup
    def lookup
      lambda do |a|
        a[self]
      end
    end
    alias ~ lookup
  end
end

class Symbol
  include Rupture::Lookup
end

class String
  include Rupture::Lookup
end

class Numeric
  include Rupture::Lookup
end

