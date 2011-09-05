require File.dirname(__FILE__) + '/test_helper'

class FnTest < Test::Unit::TestCase
  should "identity" do
    assert_equal [1,2,3].seq, [1,2,3].seq.map(F[:identity])
  end

  should "juxt" do
    assert_equal [[2,0],[3,1],[4,2]].seq, [1,2,3].seq.map(F.juxt(:inc, :dec))
  end

  should "use hash as fn" do
    assert_equal [1, 2, 3, nil].seq, [:foo, :bar, :baz, :bam].seq.map({:foo => 1, :bar => 2, :baz => 3})
  end

  should "use set and sorted set as fn" do
    assert_equal [:foo, 2, nil, :baz, nil].seq, [:foo, 2, :bar, :baz, :bam].seq.map(Set[:foo, 2, :baz])
    assert_equal [:foo, 2, nil, :baz, nil].seq, [:foo, 2, :bar, :baz, :bam].seq.map(SortedSet[:foo, 2, :baz])
  end

  should "use array as fn" do
    assert_equal [:foo, :bar, nil, :baz, :bar].seq, [0, 1, 3, 2, 1].seq.map([:foo, :bar, :baz])
  end

  should "use symbol lookup as fn" do
    assert_equal [3, nil, 7, nil].seq, [{:foo => 3}, {}, {:foo => 7}, {:bar => 1}].seq.map(:foo.lookup)
    assert_equal [3, nil, 7, nil].seq, [{:foo => 3}, {}, {:foo => 7}, {:bar => 1}].seq.map(~:foo)
  end

  should "use string lookup as fn" do
    assert_equal [3, nil, 7, nil].seq, [{'foo' => 3}, {}, {'foo' => 7}, {'bar' => 1}].seq.map('foo'.lookup)
  end

  should "use numeric lookup as fn" do
    assert_equal [3, nil, 7, nil].seq, [[0,3], {}, {1 => 7}, {'bar' => 1}].seq.map(1.lookup)
  end
end
