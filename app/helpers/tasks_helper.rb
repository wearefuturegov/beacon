module TasksHelper
  def status(completed_on)
    completed_on ? 'Completed' : 'To do'
  end

  def task_statuses
    ['To do', 'Completed']
  end

  def task_is_vulnerable_options
    ['Vulnerable']
  end

  def task_categories
    %w(Food Medicine Other)
  end
end
