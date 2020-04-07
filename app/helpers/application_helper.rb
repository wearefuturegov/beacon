# frozen_string_literal: true

module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime('%d/%m/%y %k:%M')
  end

  def humanize_text(text)
    text&.humanize
  end
end
