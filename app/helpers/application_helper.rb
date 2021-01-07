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

  SORT_DIRECTIONS = %w[ASC DESC].freeze
  SORT_ICONS = Hash[SORT_DIRECTIONS.zip(['c-icon--sort-up', 'c-icon--sort-down'])].freeze

  def sort_icon(field)
    return SORT_ICONS[params[:order_dir]] if field == params[:order]

    'c-icon--sort bg-gray'
  end

  def sort_direction(_field)
    (SORT_DIRECTIONS - [params[:order_dir]]).first
  end

  def environment_from_hostname
    if ENV['HOSTNAME'].include?('staging')
      return 'staging'
    elsif ENV['HOSTNAME'].include?('test')
      return 'test'
    elsif ENV['HOSTNAME'].include?('localhost')
      return 'development'
    elsif ENV['HOSTNAME'].include?('production')
      return 'production'
    end
  end
end
