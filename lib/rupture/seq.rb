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
end
