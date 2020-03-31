module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime("%d/%m/%y %k:%M")
  end

  def task_statuses
    ['To do', 'Completed']
  end

  def task_priorities
    %w(High Medium Low)
  end

  def task_categories
    %w(Food Medicine Other)
  end
end
