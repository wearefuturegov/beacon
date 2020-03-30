module TasksHelper
  def status(completed_on)
    completed_on ? 'Completed' : 'To do'
  end
end
