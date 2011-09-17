module Rupture; end

Enumerator = Enumerable::Enumerator unless RUBY_VERSION =~ /1.9/

require 'rupture/core_ext'
require 'rupture/rails_ext'
require 'rupture/utils'
require 'rupture/function'
require 'rupture/fn'
require 'rupture/lookup'
require 'rupture/symbol'
require 'rupture/meta'
require 'rupture/sequence'
require 'rupture/seq'
require 'rupture/lazy_seq'
require 'rupture/cons'
require 'rupture/array_seq'
require 'rupture/list'
require 'rupture/map'

F = Rupture::Function

Object.send(:include, Rupture::Meta)
