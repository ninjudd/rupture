require File.dirname(__FILE__) + '/test_helper'

class MapTest < Test::Unit::TestCase
  should "destructure" do
    a,b,c,d = {:foo => 1, :bar => 3}.destruct(:bar, :foo, :bar, :baz)

    assert_equal 3,   a
    assert_equal 1,   b
    assert_equal 3,   c
    assert_equal nil, d

    {:foo => 1, :bar => 3}.destruct(:bar, :foo, :bar, :baz) do |*args|
      assert_equal [3, 1, 3, nil], args
    end
  end

  should "update!" do
    h = {:foo => 1, :bar => [1,2,3].seq}
    h.update!(:foo, :inc)

    assert_equal({:foo => 2, :bar => [1,2,3].seq}, h)

    h.update!(:bar, :map) {|i| i + 10}
    assert_equal({:foo => 2, :bar => [11,12,13].seq}, h)

    h.update!(:foo) {|i| i + 10}
    assert_equal({:foo => 12, :bar => [11,12,13].seq}, h)
  end
end
