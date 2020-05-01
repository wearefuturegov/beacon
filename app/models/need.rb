# frozen_string_literal: true

require 'csv'

class Need < ApplicationRecord
  include Filterable
  self.ignored_columns = %w[due_by]
  before_update :enforce_single_assignment

  enum status: { to_do: 'to_do', in_progress: 'in_progress', blocked: 'blocked', complete: 'complete', cancelled: 'cancelled' }
  belongs_to :contact
  belongs_to :user, optional: true
  belongs_to :role, optional: true
  has_many :notes, dependent: :destroy

  has_paper_trail

  jsonb_accessor :supplemental_data,
                 food_priority: :string,
                 food_service_type: :string

  ASSESSMENT_CATEGORIES = ['phone triage', 'check in'].freeze

  enum category: { 'Phone triage': 'phone triage',
                   'Check in': 'check in',
                   'Groceries and cooked meals': 'groceries and cooked meals',
                   'Physical and mental wellbeing': 'physical and mental wellbeing',
                   'Financial support': 'financial support',
                   'Staying social': 'staying social',
                   'Prescription pickups': 'prescription pickups',
                   'Book drops and entertainment': 'book drops and entertainment',
                   'Dog walking': 'dog walking',
                   'Initial review': 'initial review',
                   'Other': 'other' }

  validates :category, presence: true
  validate :valid_start_on?

  def valid_start_on?
    if start_on.nil? && ASSESSMENT_CATEGORIES.include?(category.to_s.downcase) || start_on.nil? && category.nil?
      errors.add(:start_on, 'must be provided')
      false
    else
      true
    end
  end

  # validates :food_priority, inclusion: { in: %w[1 2 3] }, allow_blank: true
  # validates :food_service_type, inclusion: { in: ['Hot meal', 'Heat up', 'Grocery delivery'] }, allow_blank: true

  scope :completed, -> { where(status: :complete) }
  scope :uncompleted, -> { where.not(status: :complete) }
  scope :started, -> { where('start_on IS NULL or start_on <= ?', Date.today) }
  scope :filter_by_category, ->(category) { where(category: category.downcase) }

  scope :assessments, -> { where(category: ASSESSMENT_CATEGORIES) }
  scope :not_assessments, -> { where.not(category: ASSESSMENT_CATEGORIES) }

  scope :filter_by_user_id, lambda { |user_id|
    if user_id == 'Unassigned'
      where(user_id: nil)
    else
      where(user_id: user_id)
    end
  }

  scope :filter_by_assigned_to, lambda { |assigned_to|
    if assigned_to == 'Unassigned'
      where('user_id IS NULL and role_id IS NULL')
    else
      (assoc, unsanitised_key) = assigned_to&.split('-')
      if assoc == 'user'
        where(user_id: unsanitised_key)
      elsif assoc == 'role'
        where(role_id: unsanitised_key)
      end
    end
  }

  scope :filter_by_team, lambda { |role_id|
    where(assigned_to: User.with_role(role_id))
  }

  scope :filter_by_status, ->(status) { where(status: status) }

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
    order("last_phoned_date #{direction}")
  }

  scope :order_by_call_attempts, lambda { |direction|
    order("call_attempts #{direction} NULLS LAST")
  }

  validates :name, presence: true

  delegate :name, :address, :postcode, :telephone, :mobile, :is_vulnerable,
           :count_people_in_house, :any_dietary_requirements, :dietary_details,
           :cooking_facilities, :delivery_details, :has_covid_symptoms,
           to: :contact, prefix: true
  delegate :name, to: :user, prefix: true

  def self.to_csv
    attributes = {
      id: 'need_id',
      category: 'category',
      status: 'status',
      created_at: 'created_at',

      contact_name: 'name',
      contact_address: 'address',
      contact_postcode: 'postcode',
      contact_telephone: 'telephone',
      contact_mobile: 'mobile',

      name: 'description',
      food_priority: 'food_priority',
      food_service_type: 'food_service_type',
      contact_count_people_in_house: 'count_people_in_house',
      contact_any_dietary_requirements: 'any_dietary_requirements',
      contact_dietary_details: 'dietary_details',
      contact_cooking_facilities: 'cooking_facilities',
      contact_delivery_details: 'delivery_details',
      contact_has_covid_symptoms: 'has_covid_symptoms',

      contact_is_vulnerable: 'is_vulnerable',
      is_urgent: 'is_urgent'
    }

    CSV.generate(headers: true) do |csv|
      csv << attributes.values
      all.each do |record|
        csv << attributes.keys.map { |attr| attr == :status ? record.send(:status_label) : record.send(attr) }
      end
    end
  end

  def css_class
    "need-pane--#{category.parameterize}"
  end

  def status_label
    self[:status]&.humanize || Need.statuses[:to_do].humanize
  end

  def status=(state)
    self.completed_on = if state == 'complete'
                          DateTime.now
                        else
                          ''
                        end
    self[:status] = state
  end

  def enforce_single_assignment
    self.role_id = nil if !user.nil? && user_id_changed?
    self.user_id = nil if !role_id.nil? && role_id_changed?
  end

  def assigned_to
    if user_id
      "user-#{user_id}"
    elsif role_id
      "role-#{role_id}"
    end
  end

  def assigned_to=(assigned_to)
    (assoc, unsanitised_key) = assigned_to&.split('-')
    if assoc == 'user'
      self.user_id = unsanitised_key.to_i
      self.role_id = nil
    elsif assoc == 'role'
      self.user_id = nil
      self.role_id = unsanitised_key.to_i
    else
      self.user_id = nil
      self.role_id = nil
    end
  end

  def self.base_query
    sql = "LEFT JOIN (select c.id, max(nt.created_at) from contacts c
          left join needs n on n.contact_id = c.id
          left join notes nt on nt.need_id = n.id where nt.category like 'phone_%'
          group by c.id) as contact_aggregation
          on contact_aggregation.id = contacts.id"

    sql += " left join (
          select n.id, count(nt.id) from notes nt
          join needs n on n.id = nt.need_id and nt.category in ('phone_success', 'phone_message', 'phone_failure')
          group by n.id
        ) as notes_aggr on notes_aggr.id = needs.id"

    Need.joins(:contact, sql).select('needs.*', 'contact_aggregation.max as last_phoned_date',
                                     'notes_aggr.count as call_attempts ')
  end

  def self.default_sort(results)
    results.order(created_at: :asc)
  end

  def self.dynamic_fields
    %w[last_phoned_date call_attempts]
  end

  def self.categories_for_triage
    categories.except('Other').reject { |_k, v| v.in? ASSESSMENT_CATEGORIES }
  end

  def assigned
    if user
      user.name_or_email
    elsif role
      role.name
    else
      'Unassigned'
    end
  end

  def last_phoned_date
    read_attribute('last_phoned_date')
  end

  def call_attempts
    read_attribute('call_attempts')
  end

  # This sort method is to first sort future needs (where start_on > today) to the bottom of the list
  # and then sort by created_at
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def self.sort_created_and_start_date(first, second)
    return first.start_on <=> second.start_on if first.start_on && second.start_on
    return -1 if first.start_on.nil? && !second.start_on.nil? && second.start_on > DateTime.now
    return 1 if second.start_on.nil? && !first.start_on.nil? && first.start_on > DateTime.now

    first.created_at <=> second.created_at
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end
