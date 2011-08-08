module Rupture::Meta
  def meta
    @_meta ||= {}
  end

  def clone
    copy = super
    copy.instance_variable_set(:@_meta, @_meta ? @_meta.clone : nil)
    copy
  end
end
