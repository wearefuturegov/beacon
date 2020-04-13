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
      { label: 'Phone triage', border: '#2A2828' },
      { label: 'Groceries and cooked meals', border: '#EAD95B' },
      { label: 'Physical and mental wellbeing', border: '#F18F01' },
      { label: 'Financial support', border: '#42807B' },
      { label: 'Staying social', border: '#A0CAC9' },
      { label: 'Prescription pickups', border: '#971964' },
      { label: 'Book drops and entertainment', border: '#43387B' },
      { label: 'Dog walking', border: '#1C52A3' }
    ]
  end

  def get_need_border(category)
    (needs.find { |need| need[:label].parameterize.underscore.humanize.downcase == category })&.[](:border) || ''
  end

  def note_category_form_display(note_category)
    note_category[0].to_s if note_category.present?
  end

  def note_category_form_id(note_category)
    note_category[1].to_s if note_category.present?
  end

  def need_urgencies
    ['Urgent', 'Normal']
  end

  def build_csv_link(url)
    url.gsub('?', '.csv?')
  end
end
