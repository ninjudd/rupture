require File.dirname(__FILE__) + '/test_helper'

class SeqTest < Test::Unit::TestCase
  should "split_at index" do
    assert_equal [[1,2,3],[4,5,6]], [1,2,3,4,5,6].split_at(3)
  end

  should "partition_by predicate" do
    assert_equal [[1, 3], [2, 4], [3], [4, 8]], [1,3,2,4,3,4,8].partition_by {|i| i.odd?}
  end

  should "partition_on predicate" do
    assert_equal [[1], [nil, 4, 3], [nil, 8]], [1,nil,4,3,nil,8].partition_on {|i| i == nil}
  end
end
