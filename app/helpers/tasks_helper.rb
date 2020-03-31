module TasksHelper
  def status(completed_on)
    completed_on ? 'Completed' : 'To do'
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
