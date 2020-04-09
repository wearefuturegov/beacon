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
    needs_note_categories.sort_by {|e| e[1][:order]}.map(&:first)
  end

  def note_category_display(need_category, note_category_id)
    needs_note_categories.find { |e| e[1][:stored_as] == need_category }
      &.fetch(1)
      &.fetch(:note_categories)
      &.find { |nc| nc[:id] == note_category_id}
      &.fetch(:display)
  end

  def needs_note_categories
    {
        'Phone triage' => {
            order: 1,
            stored_as: 'phone triage',
            note_categories: [
                # prefix 'phone_' makes reporting easier
                {id: 'phone_success', display: 'Successful Phone call'},
                {id: 'phone_failure', display: 'Failed Phone call'},
            ]
        },
        'Groceries and cooked meals' => {
            order: 2,
            stored_as: 'groceries and cooked meals',
            note_categories: []
        },
        'Physical and mental wellbeing' => {
            order: 3,
            stored_as: 'physical and mental wellbeing',
            note_categories: []
        },
        'Financial support' => {
            order: 4,
            stored_as: 'financial support',
            note_categories: []
        },
        'Staying Social' => {
            order: 5,
            stored_as: 'staying social',
            note_categories: []
        },
        'Prescription pickups' => {
            order: 6,
            stored_as: 'prescription pickups',
            note_categories: []
        },
        'Book drops and entertainment' => {
            order: 7,
            stored_as: 'book drops and entertainment',
            note_categories: []
        },
        'Dog walking' => {
            order: 8,
            stored_as: 'dog walking',
            note_categories: []
        },
    }
  end

  def need_urgencies
    ['Urgent', 'Not urgent']
  end

  def build_csv_link(url)
    url.gsub('?', '.csv?')
  end
end
