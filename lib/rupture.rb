module Rupture
  # FIXME isn't totally lazy when working with > 1 collection
  # If the first is empty, the second is still seq'd
  def map(*colls, &block)
    lazy_seq do
      seqs = colls.collect(&:seq)
      if seqs.all?
        firsts = seqs.collect(&:first)
        rests  = seqs.collect(&:rest)
        cons(yield(*firsts), map(*rests, &block))
      end
    end
  end

  def concat(*colls)
    lazy_seq do
      head, *tail = colls.collect(&:seq)
      if head
        cons(head.first, concat(head.rest, *tail))
      elsif tail.any?
        concat(*tail)
      end
    end
  end

  def mapcat(*colls, &block)
    concat(*map(*colls, &block))
  end

  def lazy_seq(&block)
    LazySeq.new(&block)
  end

  def cons(head, tail)
    Cons.new(head, tail)
  end

  def list(*xs)
    List.new(*xs)
  end

  def identity(x)
    x
  end

  def juxt(*fs)
    lambda do |*args|
      fs.collect {|f| f[*args]}
    end
  end

  def decorate(*args)
    juxt(identity, *args)
  end

  extend Rupture
  R = Rupture
end

require 'rupture/core_ext'
require 'rupture/rails_ext'
require 'rupture/symbol'
require 'rupture/meta'
require 'rupture/sequence'
require 'rupture/seq'
require 'rupture/lazy_seq'
require 'rupture/cons'
require 'rupture/array_seq'
require 'rupture/list'

Object.send(:include, Rupture::Meta)
