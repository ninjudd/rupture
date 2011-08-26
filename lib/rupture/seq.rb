module Enumerable
  def split_at(n)
    [take(n), drop(n)]
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

  def partition_on(&block)
    results  = []
    each do |i|
      results << [] if yield(i) or results.empty?
      results.last << i
    end
    results
  end
end
