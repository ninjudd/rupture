module Rupture::Meta
  def meta
    @_meta ||= {}
  end

  def clone(meta = nil)
    meta ||= @_meta.clone if @_meta
    raise "meta must be of type Hash, it is #{meta.class}" unless meta.nil? or meta.kind_of?(Hash)
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
