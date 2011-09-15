require File.dirname(__FILE__) + '/test_helper'

class FunctionTest < Test::Unit::TestCase
  should "loop" do
    n = F.loop(0) do |recur, i|
      if i < 10
        recur[i.inc]
      else
        i
      end
    end
    assert_equal 10, n
  end

  should "loop lazily" do
    s = F.lazy_loop(0) do |lazy_recur, i|
      if i != 10
        F.cons(i, lazy_recur[i.inc])
      end
    end
    assert_equal (0..9).seq, s
  end
end
