class Hash
  def deep_diff(c:, o: self, d: {})
    o.each do |k, v|
      if c[k].is_a?(Hash)
        d[k] = deep_diff(c: c[k], o: v)
      elsif  v != c[k]
        d[k] = {c: c[k], o: v}
      end
    end
    c.each do |k, v|
      d[k] = {c: v, o: nil} unless o.has_key?(k)
    end
    d
  end
end
