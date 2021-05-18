# frozen_string_literal: true

module ContactsHelper
  def boolean_formatter(boolean)
    boolean ? 'Yes' : 'No'
  end

  def short_date_formatter(date)
    date&.to_s(:default)
  end
end
