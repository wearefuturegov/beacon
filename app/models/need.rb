# frozen_string_literal: true

class Need < ApplicationRecord
  include Filterable
  acts_as_paranoid

  self.ignored_columns = %w[due_by]
  before_update :enforce_single_assignment
  after_initialize :set_status

  enum status: { to_do: 'to_do', in_progress: 'in_progress', blocked: 'blocked', complete: 'complete', cancelled: 'cancelled' }
  belongs_to :contact
  belongs_to :user, optional: true
  belongs_to :role, optional: true
  has_many :notes, dependent: :destroy

  has_paper_trail

  jsonb_accessor :supplemental_data,
                 food_priority: :string,
                 food_service_type: :string

  ASSESSMENT_START_CATEGORIES = ['triage', 'check in'].freeze
  ASSESSMENT_CATEGORIES = ['triage', 'check in', 'mdt review'].freeze

  enum category: { 'Triage': 'triage',
                   'MDT review': 'mdt review',
                   'Check in': 'check in',
                   'Groceries and cooked meals': 'groceries and cooked meals',
                   'Physical and mental wellbeing': 'physical and mental wellbeing',
                   'Financial support': 'financial support',
                   'Staying social': 'staying social',
                   'Prescription pickups': 'prescription pickups',
                   'Book drops and entertainment': 'book drops and entertainment',
                   'Initial review': 'initial review',
                   'Medical transport': 'medical transport',
                   'Waste removal': 'waste removal',
                   'Repairs': 'repairs',
                   'Household tasks': 'household tasks',
                   'Dog walking': 'dog walking',
                   'Other': 'other' }

  validates :category, presence: true
  validates :name, presence: true
  validate :start_required_for_assessment

  def start_required_for_assessment
    return unless start_on.nil? && ASSESSMENT_CATEGORIES.include?(category.to_s.downcase) ||
                  start_on.nil? && category.nil?

    errors.add(:start_on, 'must be provided')
  end

  scope :completed, -> { where(status: :complete) }
  scope :uncompleted, -> { where.not(status: [:complete, :cancelled]) }
  scope :started, lambda { |start_on|
    next all if start_on.nil? || start_on == 'any_time'

    case start_on
    when 'today'
      where('start_on >= ? and start_on <= ?', Date.today, Date.today.end_of_day)
    when 'tomorrow'
      where('start_on >= ? and start_on <= ?', Date.tomorrow, Date.tomorrow.end_of_day)
    when 'next_week'
      where('start_on >= ? and start_on <= ?', Date.tomorrow, Date.today.end_of_day + 7.days)
    when 'after_today'
      where('start_on >= ?', Date.tomorrow)
    else
      raise "Invalid start_on filter #{start_on}"
    end
  }
  scope :filter_by_category, lambda { |category|
    if category == 'triages-and-check-ins'
      where(category: ['triage', 'check in'])
    elsif category == 'not-triages-and-check-ins'
      where.not(category: ['triage', 'check in'])
    else
      where(category: category.downcase)
    end
  }

  scope :assessments, -> { where(category: ASSESSMENT_CATEGORIES) }
  scope :not_assessments, -> { where.not(category: ASSESSMENT_CATEGORIES) }

  scope :not_pending, -> { where(assessment_id: nil) }

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

  scope :created_by, ->(user_id) { joins(:versions).where('whodunnit = ? and event = ?', user_id.to_s, 'create') }

  scope :filter_by_is_urgent, lambda { |is_urgent|
    is_urgent = is_urgent.downcase
    if is_urgent == 'urgent'
      where(is_urgent: true)
    else
      where.not(is_urgent: true)
    end
  }

  scope :order_by_created_at, lambda { |direction|
    order("needs.created_at #{direction}")
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

  scope :order_by_assigned_to, lambda { |direction|
    order("user_id #{direction}, role_id #{direction}")
  }

  scope :order_start_on, lambda { |direction|
    order("start_on #{direction}")
  }

  delegate :name, :address, :postcode, :telephone, :mobile, :is_vulnerable,
           :count_people_in_house, :any_dietary_requirements, :dietary_details,
           :cooking_facilities, :delivery_details, :has_covid_symptoms,
           to: :contact, prefix: true
  delegate :name, to: :user, prefix: true

  def no_notes_by_somebody_else?(user_id)
    notes.without_deleted.reject { |x| x.user_id == user_id }.empty?
  end

  def notes_by_somebody_else?(user_id)
    !no_notes_by_somebody_else?(user_id)
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
    sql = "LEFT JOIN (select c.id, max(nt.created_at) as last_phoned_date from contacts c
          left join needs n on n.contact_id = c.id
          left join notes nt on nt.need_id = n.id where nt.category like 'phone_%' and nt.deleted_at IS NULL
          group by c.id) as contact_aggregation
          on contact_aggregation.id = contacts.id"

    sql += " left join (
          select n.id, count(nt.id) as call_attempts from notes nt
          join needs n on n.id = nt.need_id and nt.category in ('phone_success', 'phone_message', 'phone_failure')
          where nt.deleted_at IS NULL
          group by n.id
        ) as notes_aggr on notes_aggr.id = needs.id"

    Need.joins(:contact, sql)
        .where(assessment_id: nil)
        .select('needs.*', 'last_phoned_date',
                'call_attempts')
  end

  def created_by_name
    record = versions.where('event = ?', 'create').first
    user_id = record.present? ? record.whodunnit : nil
    return 'No user' if user_id.nil?

    user = User.find(user_id)
    user.name_or_email
  end

  def self.default_sort(results)
    results.order(created_at: :asc)
  end

  def self.dynamic_fields
    %w[last_phoned_date call_attempts assigned_to]
  end

  def self.categories_for_triage
    categories.except('Other').reject { |_k, v| v.in? ASSESSMENT_CATEGORIES }
  end

  # superseed the method aboves once triage gets removed
  def self.categories_for_assessment
    categories.reject { |_k, v| v.in? ASSESSMENT_CATEGORIES }
  end

  def assessment?
    category.downcase.in? ASSESSMENT_CATEGORIES
  end

  def assessment_start?
    category.downcase.in? ASSESSMENT_START_CATEGORIES
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

  private

  def set_status
    self.status ||= :to_do if new_record?
  end
end
