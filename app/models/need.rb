# frozen_string_literal: true

require 'csv'

class Need < ApplicationRecord
  include Filterable

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
    Need.includes(:user, :contact)
  end

  def self.default_sort(results)
    results.order(created_at: :asc)
  end

  def assigned
    if user
      user.name_or_email
    else
      'Unassigned'
    end
  end

  def last_phoned_date
    contact.needs.joins(:notes).select('notes.created_at').where('notes.category LIKE ?', 'phone_%').order('notes.created_at DESC').pluck(:'notes.created_at').first
  end
end
