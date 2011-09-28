module Rupture::Meta
  def meta
    @_meta ||= {}
  end

  def clone(meta = nil)
    meta ||= @_meta.clone if @_meta
    unless meta.nil? or meta.kind_of?(Hash) or meta.kind_of?(Rupture::HashMap)
      raise "meta must be of type Hash or Rupture::HashMap, it is #{meta.class}"
    end
    copy = super()
    copy.instance_variable_set(:@_meta, meta)
    copy
  end

  def with_meta(meta)
    clone(meta)
  end

  def vary_meta(*args, &fn)
    fn ||= args.shift
    with_meta(fn[meta, *args])
  end
end
