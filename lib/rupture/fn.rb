module Rupture::Fn
  def self.identity
    lambda {|x| x}
  end
end

class Proc
  def complement
    lambda do |*args|
      not call(*args)
    end
  end
end
