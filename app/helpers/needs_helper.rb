module NeedsHelper
  def status(completed_on)
    completed_on ? 'Completed' : 'To do'
  end

  def need_statuses
    ['To do', 'Completed']
  end

  def page_sizes
    [10, 100, 1000, 10000]
  end


  def need_is_vulnerable_options
    ['Vulnerable']
  end

  def need_categories
    %w(Food Medicine Other)
  end

  def needs
    ['Phone triage','Groceries and cooked meals', 'Physical and mental wellbeing', 'Financial support',
     'Staying Social', 'Prescription pickups', 'Book drops and entertainment', 'Dog walking']
  end

  def need_urgencies
    ['Urgent', 'Not urgent']
  end
end
