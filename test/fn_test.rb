require File.dirname(__FILE__) + '/test_helper'

class FnTest < Test::Unit::TestCase
  should "identity" do
    assert_equal [1,2,3].seq, [1,2,3].map(&Fn.identity)
  end

  should "juxt" do
    assert_equal [[2,0],[3,1],[4,2]].seq, [1,2,3].map(&Fn.juxt(Numeric.fn(:inc), Numeric.fn(:dec)))
  end
end
