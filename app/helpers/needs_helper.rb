# frozen_string_literal: true

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
    %w[Food Medicine Other]
  end

  def needs
    ['Phone triage', 'Groceries and cooked meals', 'Physical and mental wellbeing', 'Financial support',
     'Staying Social', 'Prescription pickups', 'Book drops and entertainment', 'Dog walking']
  end

  def note_category_display(note_category_id)
    note_category = needs_note_categories.find { |category| category[:id] == note_category_id }
    note_category.present? ? note_category[:display] : 'Note'
  end

  def needs_note_categories
    [
      # prefix 'phone_' makes reporting easier
      { id: 'note', display: 'Note' },
      { id: 'phone_success', display: 'Successful Call' },
      { id: 'phone_message', display: 'Left Message' },
      { id: 'phone_failure', display: 'Failed Call' }
    ]
  end

  def need_urgencies
    ['Urgent', 'Not urgent']
  end

  def build_csv_link(url)
    url.gsub('?', '.csv?')
  end
end
