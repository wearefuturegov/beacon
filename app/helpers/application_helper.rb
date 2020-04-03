module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime("%d/%m/%y %k:%M")
  end
  def humanize_text(text)
    text.humanize unless text == nil
  end
end
