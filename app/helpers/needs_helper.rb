module NeedsHelper
  def status(completed_on)
    completed_on ? 'Completed' : 'To do'
  end

  def need_statuses
    ['To do', 'Completed']
  end

  def need_is_vulnerable_options
    ['Vulnerable']
  end

  def need_categories
    %w(Food Medicine Other)
  end

  def needs
    ['Phone Triage','Groceries and cooked meals', 'Physical and mental wellbeing', 'Financial support',
     'Staying Social', 'Prescription pickups', 'Book drops and entertainment', 'Dog walking']
  end
end
