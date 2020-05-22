# frozen_string_literal: true

module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime('%d/%m/%y %k:%M')
  end

  def humanize_text(text)
    text&.humanize
  end

  def dash_if_empty(value)
    if value && !value.to_s.empty?
      value
    else
      '—'
    end
  end

  def friendly_boolean(value)
    if value == true
      'Yes'
    elsif value == false
      'No'
    else # nil
      '—'
    end
  end

  def current_role_id
    current_user.role&.id
  end

  def wizard_state_as_class(state)
    case state
    when -2
      'failed-step inactive'
    when -1
      'failed-step'
    when 1
      'current-step'
    when 2
      'completed-step'
    else
      ''
    end
  end
end
