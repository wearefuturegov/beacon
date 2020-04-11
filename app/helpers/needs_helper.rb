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
    [
      {
        label: 'Phone triage',
        border: '2px solid #d8853d'
      },
      {
        label: 'Groceries and cooked meals',
        border: '2px solid red'
      },
      {
        label: 'Physical and mental wellbeing',
        border: '2px solid green'
      },
      {
        label: 'Financial support',
        border: '2px solid #d8853d'
      },
      {
        label: 'Staying Social',
        border: '2px solid #d8853d'
      },
      {
        label: 'Prescription pickups',
        border: '2px solid #d8853d'
      },
      {
        label: 'Book drops and entertainment',
        border: '2px solid #d8853d'
      },
      {
        label: 'Dog walking',
        border: '2px solid #d8853d'
      }
    ]
  end

  def get_need_border(category)
    (needs.find { |need| need[:label].parameterize.underscore.humanize.downcase == category })&.[](:border) || ''
  end

  def need_urgencies
    ['Urgent', 'Normal']
  end

  def build_csv_link(url)
    url.gsub('?', '.csv?')
  end
end
