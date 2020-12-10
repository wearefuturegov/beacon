# frozen_string_literal: true

module CleanData
  extend ActiveSupport::Concern

  def strip_whitespace
    attributes.each do |name, value|
      send("#{name}=", send(name).strip) if value.respond_to?(:strip)
    end
  end
end
