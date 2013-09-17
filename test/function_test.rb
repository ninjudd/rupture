require File.dirname(__FILE__) + '/test_helper'

class FunctionTest < Test::Unit::TestCase
  should "loop" do
    n = F.loop(0) do |recur, i|
      if i < 10
        recur[i.inc]
      else
        i
      end
    end
    assert_equal 10, n
  end

  should "loop lazily" do
    s = F.lazy_loop(0) do |recur, i|
      if i != 10
        F.cons(i, recur[i.inc])
      end
    end
    assert_equal (0..9).seq, s
  end

  should "comprehend lists" do
    assert_equal [[1,3],[1,4],[1,5],[2,3],[2,4],[2,5],[3,3],[3,4],[3,5]].seq,
                 F.for([1,2,3], [3,4,5]) {|a, b| [a,b]}
  end

  should "let stuff" do
    a = 0
    c = F.let(1,2) do |a,b|
      assert_equal 1, a
      assert_equal 2, b
      a + b
    end
    assert_equal 3, c

    assert_equal a, 0 if RUBY_VERSION =~ /1.9/ # 1.8 only has lexical scope for functions.

    c = 1.let(2) do |a,b|
      assert_equal 1, a
      assert_equal 2, b
      a + b
    end
    assert_equal 3, c

    assert_equal a, 0 if RUBY_VERSION =~ /1.9/ # 1.8 only has lexical scope for functions.

    if RUBY_VERSION =~ /1.9/
      c = F.let do |a = 1, b = 2|
        assert_equal 1, a
        assert_equal 2, b
        a + b
      end
      assert_equal 3, c
    end
  end

  should "when_let" do
    assert_equal nil, F.when_let(false) {|a| a + 1}
    assert_equal nil, F.when_let(nil)   {|a| a + 1}
    assert_equal 2,   F.when_let(1)     {|a| a + 1}
  end

  should "fix stuff" do
    assert_equal 1, F.fix(1,:even?,:inc)
    assert_equal 1, 1.fix(:even?,:inc)

    assert_equal 3, F.fix(2,:even?,:inc)
    assert_equal 3, 2.fix(:even?,:inc)

    assert_equal 12, F.fix(2,:even?) {|i| i + 10}
    assert_equal 12, 2.fix(:even?) {|i| i + 10}
  end
end
