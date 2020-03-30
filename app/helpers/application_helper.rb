module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime("%-d %B %Y %k:%M%P")
  end
end
