require File.dirname(__FILE__) + '/test_helper'

class SeqTest < Test::Unit::TestCase
  empty_seqs = [nil, [], Seq.empty, LazySeq.new, LazySeq.new{nil}, LazySeq.new{[]}]

  should "empty seqs" do
    empty_seqs.each do |s|
      assert_nil s.seq
      assert_nil s.first
      assert     s.rest
    end
  end

  should "empty lazy_seqs" do
    empty_seqs.each do |s|
      assert_nil LazySeq.new{s}.seq
    end
  end

  should "cons" do
    empty_seqs.each do |cdr|
      cons = Cons.new(1,cdr)
      assert          cons.seq
      assert_equal 1, cons.first
      assert          cons.rest
      assert_nil      cons.next
      assert_nil      cons.rest.seq

      cons = Cons.new(2, cons)
      assert          cons.seq
      assert_equal 2, cons.first
      assert          cons.rest
      assert          cons.next
      assert          cons.rest.seq
    end
  end

  should "take" do

  end

  # should "partition" do
  #   assert_equal [[1,2],[3,4]],       [1,2,3,4,5].partition(2)
  #   assert_equal [[1,2],[2,3],[3,4]], [1,2,3,4].partition(2,1)
  #   assert_equal [[1,2],[4,5]],       [1,2,3,4,5].partition(2,3)
  #   assert_equal [[1,2],[3,4],[5,6]], [1,2,3,4,5].partition(2,2,[6,6,6])
  # end

  # should "partition with block" do
  #   assert_equal [[1,3,5],[2,4,6]], [1,2,3,4,5,6].partition(&:odd?)
  # end

  # should "partition_all" do
  #   assert_equal [[1,2],[3,4],[5]], [1,2,3,4,5].partition_all(2)
  #   assert_equal [[1,2],[2,3],[3]], [1,2,3].partition_all(2,1)
  # end

  # should "partition_by" do
  #   assert_equal [[1,3], [2,4], [3], [4,8]], [1,3,2,4,3,4,8].partition_by {|i| i.odd?}
  # end

  # should "partition_between" do
  #   assert_equal [[1], [nil, 4, 3], [nil, 8]], [1,nil,4,3,nil,8].partition_between {|a,b| b == nil}
  # end

  # should "split_at" do
  #   assert_equal [[1,2,3],[4,5,6]], [1,2,3,4,5,6].split_at(3)
  # end

  # should "split_with" do
  #   assert_equal [[1,2,3],[4,5,6]], [1,2,3,4,5,6].split_with {|i| i < 4}
  # end
end
