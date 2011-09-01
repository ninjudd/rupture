module Rupture; end

require 'rupture/core_ext'
require 'rupture/meta'
require 'rupture/seqable'
require 'rupture/seq'
require 'rupture/lazy_seq'
require 'rupture/cons'
require 'rupture/array_seq'

Seq      = Rupture::Seq
Cons     = Rupture::Cons
LazySeq  = Rupture::LazySeq

Object.send(:include, Rupture::Meta)
