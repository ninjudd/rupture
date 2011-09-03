require File.dirname(__FILE__) + '/test_helper'

class ListTest < Test::Unit::TestCase
  should "act like a seq" do
    list = F.list(1, 2, 3, 4)
    assert_equal list.count,                4
    assert_equal list.first,                1
    assert_equal list.rest.next.rest.first, 4
    assert_nil   list.next.next.next.next
  end

  should "count quickly" do
    list = F.list(1, 2, 3, 4)
    def list.each
      raise "Tried to compute count by doing O(N) walk"
    end

    assert_equal list.count, 4
  end
end
