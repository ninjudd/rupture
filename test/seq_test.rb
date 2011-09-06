require File.dirname(__FILE__) + '/test_helper'

class SeqTest < Test::Unit::TestCase
  empty_seqs = [nil, [], Rupture::Seq.empty, F.lazy_seq{nil}, F.lazy_seq{[]}]

  def numbers(i)
    F.lazy_seq { F.cons(i, numbers(i.inc))}
  end

  should "empty seqs" do
    empty_seqs.each do |s|
      assert_nil s.seq
      assert_nil s.seq.first
      assert     s.seq.rest
    end
  end

  should "empty lazy_seqs" do
    empty_seqs.each do |s|
      assert_nil F.lazy_seq{s}.seq
    end
  end

  should "convert enumerables into seq" do
    assert_equal [20,21,22].seq, (-22..22).seq.drop(42)
    assert_equal [101,102].seq,  (1..200).seq.drop(100).take(2)
    assert_equal "bbq",          ("bar".."foo").seq.drop(25).first
  end

  should "cons" do
    empty_seqs.each do |cdr|
      cons = F.cons(1,cdr)
      assert          cons.seq
      assert_equal 1, cons.first
      assert          cons.rest
      assert_nil      cons.next
      assert_nil      cons.rest.seq

      cons = F.cons(2, cons)
      assert          cons.seq
      assert_equal 2, cons.first
      assert          cons.rest
      assert          cons.next
      assert          cons.rest.seq
    end
  end

  should "map" do
    assert_equal [9,12,15].seq, F.map([1,2,3],[3,4,5],[5,6,7]) {|a,b,c| a + b + c}
    assert_equal [9,12,15].seq, [3,4,5].seq.map {|a| a * 3}
  end

  should "concat" do
    assert_equal [1,2,3,4,5,6].seq, F.concat([1,2],[3,4,5],[6])
    assert_equal [1,2,3,4,5,6].seq, [1,2].seq.concat([3,4,5],[6])
  end

  should "mapcat" do
    assert_equal [1,3,5,2,4,6,3,5,7].seq, F.mapcat([1,2,3],[3,4,5],[5,6,7]) {|a,b,c| [a,b,c]}
    assert_equal [1,1,2,3,2,1,2,3].seq,   [1,2].seq.mapcat {|a| [a,1,2,3]}
  end

  should "reduce" do
    assert_equal 10,  [1,2,3,4].reduce(:+)
    assert_equal 240, [1,2,3,4].reduce(:*, 10)
  end

  should "take" do
    nums = [1,2,3,4,5,6,7,8,9,10].seq

    assert_equal nums,             numbers(1).take(10)
    assert_equal Rupture::LazySeq, nums.take(10).class
    assert_equal nums,             nums.take(10)

    assert nums.take(0) # lazy-seq, not nil
  end

  should "every?" do
    assert_equal true,  [2,4,6,8,10].seq.every?(:even?)
    assert_equal false, [2,4,6,8,11].seq.every?(:even?)
    assert_equal true,  [2,4,8].seq.every?
    assert_equal false, [2,nil,4,8].seq.every?
  end

  should "some" do
    assert_equal true, [2,4,6,8,11].seq.some(:even?)
    assert_equal nil,  [2,4,6,8,10].seq.some(:odd?)
    assert_equal 2,    [2,4,8].seq.some
    assert_equal nil,  [false,false,nil].seq.some
  end

  should "drop" do
    nums = [101,102,103,104,105,106,107,108,109,110].seq

    assert_equal nums,        numbers(1).drop(100).take(10)
    assert_equal [110].seq,   nums.drop(9)
    assert_equal [1,2,3].seq, [1,2,3].seq.drop(0)

    assert nums.drop(100)
  end

  should "split_at" do
    assert_equal [[1,2,3].seq,[4,5,6].seq], [1,2,3,4,5,6].seq.split_at(3)
  end

  should "take_while" do
    nums = [1,2,3,4,5,6,7].seq

    assert_equal nums,             numbers(1).take_while {|i| i < 8}
    assert_equal Rupture::LazySeq, nums.take_while {|i| i < 3}.class
    assert_equal [1,2].seq,        nums.take_while {|i| i < 3}
  end

  should "drop_while" do
    nums = [11,12,13,14,15,16,17].seq

    assert_equal nums,             numbers(1).drop_while {|i| i < 11}.take(7)
    assert_equal Rupture::LazySeq, nums.drop_while {|i| i < 16}.class
    assert_equal [16,17].seq,      nums.drop_while {|i| i < 16}
  end

  should "split_with" do
    assert_equal [[1,2,3].seq,[4,5,6].seq], [1,2,3,4,5,6].seq.split_with {|i| i < 4}
  end

  should "==" do
    a = F.cons(1, F.cons(2, nil))
    b = F.cons(1, nil)
    c = F.list(1, 2)

    assert_equal     a, c
    assert_not_equal a, b
    assert_not_equal b, c
  end

  should "filter" do
    assert_equal -[2,4,6], [1,2,3,4,5,6].seq.filter(:even?)
  end

  should "remove" do
    assert_equal -[1,3,5], [1,2,3,4,5,6].seq.remove(:even?)
  end

  should "separate" do
    assert_equal [-[2,4,6],-[1,3,5]], [1,2,3,4,5,6].seq.separate(:even?)
  end

  should "flatten" do
    base = [1,3,5].seq
    assert_equal base, base.flatten
    assert_equal base, [[1,3,[[5]]]].seq.flatten
  end

  should "iterate" do
    assert_equal [1024, 2048].seq, F.iterate(1) {|x| x * 2}.drop(10).take(2)
    assert_equal [11, 12, 13].seq, F.iterate(:inc, 1).drop(10).take(3)
  end

  should "repeat" do
    assert_equal [1,1,1].seq,      F.repeat(1).take(3)
    assert_equal [:foo, :foo].seq, F.repeat(2,:foo)
    assert_equal nil,              F.repeat(0,:foo).seq
    assert_equal nil,              F.repeat(-1,:foo).seq
  end

  should "repeatedly" do
    i = 0
    f = lambda {i += 1}

    assert_equal [1,2,3].seq, F.repeatedly(f).take(3)
    assert_equal [4,5].seq,   F.repeatedly(2,f)
    assert_equal nil,         F.repeatedly(0,f).seq
    assert_equal nil,         F.repeatedly(-1,f).seq
  end

  should "partition" do
    assert_equal [[1,2],[3,4]].seq.map(:seq),       [1,2,3,4,5].seq.partition(2)
    assert_equal [[1,2],[2,3],[3,4]].seq.map(:seq), [1,2,3,4].seq.partition(2,1)
    assert_equal [[1,2],[4,5]].seq.map(:seq),       [1,2,3,4,5].seq.partition(2,3)
    assert_equal [[1,2],[3,4],[5,6]].seq.map(:seq), [1,2,3,4,5].seq.partition(2,2,[6,6,6])
  end

  should "partition_all" do
    assert_equal [[1,2],[3,4],[5]].seq.map(:seq), [1,2,3,4,5].seq.partition_all(2)
    assert_equal [[1,2],[2,3],[3]].seq.map(:seq), [1,2,3].seq.partition_all(2,1)
  end

  should "partition_by" do
    assert_equal [[1,3,5,3,9]].seq.map(:seq),              [1,3,5,3,9].seq.partition_by {|i| i.odd?}
    assert_equal [[1,3], [2,4], [3], [4,8]].seq.map(:seq), [1,3,2,4,3,4,8].seq.partition_by {|i| i.odd?}
  end

  should "partition_between" do
    assert_equal [[1], [nil, 4, 3], [nil, 8]].seq.map(:seq), [1,nil,4,3,nil,8].seq.partition_between {|a,b| b == nil}
  end
end
