# frozen_string_literal: true

module CleanData
  extend ActiveSupport::Concern

  # Strip Leading and Trailing Whitespace from text and string fields
  # Include on an ApplicationRecord object via:
  # 'include CleanData'
  module ClassMethods
    # If only would like to strip whitespace from specific attributes/fields
    # 'trim_fields :first_name, :middle_names, :surname'
    def trim_fields(*field_list)
      before_validation do
        field_list.each do |field|
          send("#{field}=", send(field).strip) if send(field).respond_to?('strip')
        end
      end
    end
  end

  # Strip on all model attributes/fields:
  # 'before_validate :strip_whitespace_from_all_text_and_strings'
  # 'before_save :strip_whitespace_from_all_text_and_strings'
  def strip_whitespace_from_all_text_and_strings
    attributes.each do |name, value|
      send("#{name}=", send(name).strip) if value.respond_to?(:strip)
    end
  end
end
