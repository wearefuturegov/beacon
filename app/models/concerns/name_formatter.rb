# frozen_string_literal: true

module NameFormatter
  extend ActiveSupport::Concern

  # On names which are wholly upcased or downcased this
  # method will titleize them i.e. 'RENEE MULLAN' becomes
  # 'Renee Mullan'
  def format_name(name)
    [name.upcase, name.downcase].include?(name) ? name.titleize : name
  end
end
