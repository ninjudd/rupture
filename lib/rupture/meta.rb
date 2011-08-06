module Rupture::Meta
  def meta
    if @_meta_data.nil?
      @_meta_data = {}
      @_meta_id   = object_id
    elsif @_meta_id != object_id
      @_meta_data = @_meta_data.clone
      @_meta_id   = object_id
    end
    @_meta_data
  end
end
