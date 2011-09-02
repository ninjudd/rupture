module Rupture::Fn
  def self.identity
    lambda {|x| x}
  end
end
