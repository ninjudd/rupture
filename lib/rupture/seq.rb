module Enumerable
  def split_at(n)
    [take(n), drop(n)]
  end

  def partition(n, step = n, pad = nil)
    results = []
    coll = self

    while coll.size >= n
      results << coll.take(n)
      coll = coll.drop(step)
    end

    if pad and coll.any?
      results << coll + pad.take(n - coll.size)
    end
    results
  end

  def partition_all(n, step = n)
    partition(n, step, [])
  end

  def partition_by
    results  = []
    previous = nil

    each do |i|
      current = yield(i)
      results << [] if current != previous or results.empty?
      results.last << i
      previous = current
    end
    results
  end

  def partition_between
    return [] if empty?
    results = [[first]]

    partition(2, 1).each do |(a,b)|
      results << [] if yield(a,b)
      results.last << b
    end
    results
  end
end
