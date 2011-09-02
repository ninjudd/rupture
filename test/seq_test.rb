require File.dirname(__FILE__) + '/test_helper'

class Array
  include Rupture::Seqable
end

class SeqTest < Test::Unit::TestCase
  empty_seqs = [nil, [], Seq.empty, LazySeq.new, LazySeq.new{nil}, LazySeq.new{[]}]

  def numbers(i)
    LazySeq.new { Cons.new(i, numbers(i.inc))}
  end

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
    nums = [1,2,3,4,5,6,7,8,9,10]

    assert_equal nums.seq, numbers(1).take(10)
    assert_equal LazySeq,  nums.take(10).class
    assert_equal nums.seq, nums.take(10)
  end

  should "every" do
    nums = [1,2,3,4,5,6,7,8,9,10]

    assert_equal nums.seq, numbers(1).take(10)
    assert_equal nums.seq, nums.take(10)
  end

  should "drop" do
    nums = [101,102,103,104,105,106,107,108,109,110]

    assert_equal nums.seq,  numbers(1).drop(100).take(10)
    assert_equal [110].seq, nums.drop(9)
  end

  should "take_while" do
    nums = [1,2,3,4,5,6,7]

    assert_equal nums.seq,  numbers(1).take_while {|i| i < 8}
    assert_equal LazySeq,   nums.take_while {|i| i < 3}.class
    assert_equal [1,2].seq, nums.take_while {|i| i < 3}
  end

  should "drop_while" do
    nums = [11,12,13,14,15,16,17]

    assert_equal nums.seq,    numbers(1).drop_while {|i| i < 11}.take(7)
    assert_equal LazySeq,     nums.drop_while {|i| i < 16}.class
    assert_equal [16,17].seq, nums.drop_while {|i| i < 16}
  end

  should "split_at" do
    assert_equal [[1,2,3].seq,[4,5,6].seq], [1,2,3,4,5,6].split_at(3)
  end

  should "split_with" do
    assert_equal [[1,2,3].seq,[4,5,6].seq], [1,2,3,4,5,6].split_with {|i| i < 4}
  end

  should "==" do
    a = Cons.new(1, Cons.new(2, nil))
    b = Cons.new(1, nil)
    c = List.new(1, 2)

    assert_equal     a, c
    assert_not_equal a, b
    assert_not_equal b, c
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
end
