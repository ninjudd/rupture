require File.dirname(__FILE__) + '/test_helper'

class SeqTest < Test::Unit::TestCase
  should "split_at" do
    assert_equal [[1,2,3],[4,5,6]], [1,2,3,4,5,6].split_at(3)
  end

  should "partition" do
    assert_equal [[1,2],[3,4]],       [1,2,3,4,5].partition(2)
    assert_equal [[1,2],[2,3],[3,4]], [1,2,3,4].partition(2,1)
    assert_equal [[1,2],[4,5]],       [1,2,3,4,5].partition(2,3)
    assert_equal [[1,2],[3,4],[5,6]], [1,2,3,4,5].partition(2,2,[6,6,6])
  end

  should "partition_all" do
    assert_equal [[1,2],[3,4],[5]], [1,2,3,4,5].partition_all(2)
    assert_equal [[1,2],[2,3],[3]], [1,2,3].partition_all(2,1)
  end

  should "partition_by" do
    assert_equal [[1,3], [2,4], [3], [4,8]], [1,3,2,4,3,4,8].partition_by {|i| i.odd?}
  end

  should "partition_between" do
    assert_equal [[1], [nil, 4, 3], [nil, 8]], [1,nil,4,3,nil,8].partition_between {|a,b| b == nil}
  end
end
