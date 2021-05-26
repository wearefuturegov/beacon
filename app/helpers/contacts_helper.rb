# frozen_string_literal: true

module ContactsHelper
  def boolean_formatter(boolean)
    boolean ? 'Yes' : 'No'
  end

  def short_date_formatter(date)
    date&.to_s(:default)
  end

  def titleize_formatter(name)
    name = name.to_s
    [name.upcase, name.downcase].include?(name) ? name.titleize : name
  end
end
