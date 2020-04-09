# frozen_string_literal: true

module ContactsHelper
  def boolean_formatter(boolean)
    boolean ? 'Yes' : 'No'
  end
end
