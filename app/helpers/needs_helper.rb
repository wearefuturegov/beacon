# frozen_string_literal: true

module NeedsHelper
  def need_statuses
    Need.statuses.map { |k, v| [v.humanize, k] }
  end

  def need_is_vulnerable_options
    ['Shielded']
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

  def always_visible_needs(needs)
    result = {}
    needs.needs_list.each do |key, value|
      result[key] = value if ['Groceries and cooked meals', 'Physical and mental wellbeing', 'Financial support', 'Medical transport'].include? value[:name]
    end

    result
  end

  def hidden_needs(needs)
    result = {}
    needs.needs_list.each do |key, value|
      result[key] = value unless ['Groceries and cooked meals', 'Physical and mental wellbeing', 'Financial support', 'Medical transport'].include? value[:name]
    end

    result
  end
end
