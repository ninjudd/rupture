module Rupture
end

require 'rupture/core_ext'
require 'rupture/meta'
require 'rupture/fn'
require 'rupture/seqable'
require 'rupture/seq'
require 'rupture/lazy_seq'
require 'rupture/cons'
require 'rupture/array_seq'
require 'rupture/list'

Fn       = Rupture::Fn
Seq      = Rupture::Seq
Cons     = Rupture::Cons
LazySeq  = Rupture::LazySeq
List     = Rupture::List

Object.send(:include, Rupture::Meta)
