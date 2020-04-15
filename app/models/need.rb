# frozen_string_literal: true

require 'csv'

class Need < ApplicationRecord
  include Filterable
  self.ignored_columns = %w[due_by]

  belongs_to :contact, counter_cache: true
  belongs_to :user, optional: true
  has_many :notes, dependent: :destroy

  has_paper_trail

  scope :completed, -> { where.not(completed_on: nil) }
  scope :uncompleted, -> { where(completed_on: nil) }
  scope :filter_by_category, ->(category) { where(category: category.downcase) }

  scope :filter_by_user_id, lambda { |user_id|
    if user_id == 'Unassigned'
      where(user_id: nil)
    else
      where(user_id: user_id)
    end
  }

  scope :filter_by_status, lambda { |status|
    status = status.downcase
    if status == 'to do'
      where(completed_on: nil)
    else
      where.not(completed_on: nil)
    end
  }

  scope :filter_by_is_urgent, lambda { |is_urgent|
    is_urgent = is_urgent.downcase
    if is_urgent == 'urgent'
      where(is_urgent: true)
    else
      where.not(is_urgent: true)
    end
  }

  scope :order_by_category, lambda { |direction|
    order("LOWER(category) #{direction}")
  }

  scope :order_by_last_phoned_date, lambda { |direction|
    order("last_phoned_date #{direction} NULLS LAST")
  }

  counter_culture :contact,
                  column_name: proc { |model| model.completed_on ? 'completed_needs_count' : 'uncompleted_needs_count' },
                  column_names: {
                    Need.uncompleted => :uncompleted_needs_count,
                    Need.completed => :completed_needs_count
                  }

  validates :name, presence: true

  delegate :name, :is_vulnerable, :address, :telephone, to: :contact, prefix: true
  delegate :name, to: :user, prefix: true

  def self.to_csv
    attributes = %w[contact_name category name status contact_address contact_telephone contact_is_vulnerable is_urgent created_at]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |record|
        csv << attributes.map { |attr| record.send(attr) }
      end
    end
  end

  def css_class
    "need-pane--#{category.parameterize}"
  end

  def status
    completed_on.present? ? 'Complete' : 'To do'
  end

  def status=(state)
    self.completed_on = if state == 'Complete'
                          DateTime.now
                        else
                          ''
                        end
    save
  end

  def self.base_query
    sql = "LEFT JOIN (select c.id, max(nt.created_at) from contacts c
          left join needs n on n.contact_id = c.id
          left join notes nt on nt.need_id = n.id where nt.category like 'phone_%'
          group by c.id) as contact_aggregation
          on contact_aggregation.id = contacts.id"

    Need.joins(:contact, sql).select('needs.*', 'contact_aggregation.max as last_phoned_date')
  end

  def self.default_sort(results)
    results.order(created_at: :asc)
  end

  def self.dynamic_fields
    %w[last_phoned_date]
  end

  def assigned
    if user
      user.name_or_email
    else
      'Unassigned'
    end
  end

  def last_phoned_date
    read_attribute('last_phoned_date')
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def self.sort_created_and_start_date(first, second)
    return first.start_on <=> second.start_on if first.start_on && second.start_on
    return -1 if first.start_on.nil? && !second.start_on.nil? && second.start_on > DateTime.now
    return 1 if second.start_on.nil? && !first.start_on.nil? && first.start_on > DateTime.now

    first.created_at <=> second.created_at
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end
