module Rupture; end
require 'rupture/core_ext'
require 'rupture/meta'
require 'rupture/seq'

Object.send(:include, Rupture::Meta)
