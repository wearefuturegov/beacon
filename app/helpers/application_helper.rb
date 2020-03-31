module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime("%d/%m/%y %k:%M")
  end
end
