require File.dirname(__FILE__) + '/test_helper'

class MetaTest < Test::Unit::TestCase
  should "have meta data" do
    a = "foo"

    assert_equal({}, a.meta)

    a.meta[:foo] = 1
    a.meta[:bar] = 2
    assert_equal({:foo => 1, :bar => 2}, a.meta)

    b = a.clone
    b.meta[:foo] = 3
    assert_equal({:foo => 1, :bar => 2}, a.meta)
    assert_equal({:foo => 3, :bar => 2}, b.meta)
  end

  should "change meta using with_meta" do
    a = [1,2,3]
    assert_equal({}, a.meta)

    b = a.with_meta(:foo => 1)
    assert_equal({:foo => 1}, b.meta)

    c = b.with_meta(:baz => 1)
    assert_equal({:baz => 1}, c.meta)
  end

  should "change meta using vary_meta" do
    a = [1,2,3]
    assert_equal({}, a.meta)

    b = a.vary_meta do |m|
      m[:foo] = 1
      m
    end
    assert_equal({:foo => 1}, b.meta)

    c = b.vary_meta(:merge, :bar => 3)
    assert_equal({:foo => 1, :bar => 3}, c.meta)
  end
end
