require File.dirname(__FILE__) + '/test_helper'

class ListTest < Test::Unit::TestCase
  should "constructors" do
    list = List.new(1, 2, 3, 4)
    assert_equal list.count,                4
    assert_equal list.first,                1
    assert_equal list.rest.next.rest.first, 4
    assert_nil   list.next.next.next.next
  end

  should "count be fast" do
    list = List.new(1, 2, 3, 4)
    list.expects(:each).never

    assert_equal list.count, 4
  end
end
