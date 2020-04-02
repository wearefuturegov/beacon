module SqlLogFilter
  FILTERS = Set.new(%w(token))
  def render_bind(attribute, value)
    return '<filtered>' if FILTERS.include?(attribute.name)
    super
  end

end
ActiveRecord::LogSubscriber.prepend SqlLogFilter