# frozen_string_literal: true

class Contact < ApplicationRecord
  require 'activerecord-import/base'
  require 'activerecord-import/active_record/adapters/postgresql_adapter'
  include CleanData
  include NameFormatter
  before_save :update_telephone
  before_save :update_mobile

  before_validation :strip_whitespace_from_all_text_and_strings

  has_many :needs, dependent: :destroy
  has_many :uncompleted_needs, -> { uncompleted }, class_name: 'Need'
  has_many :completed_needs, -> { completed }, class_name: 'Need'

  belongs_to :role, foreign_key: 'lead_service_id', optional: true
  belongs_to :imported_item, optional: true

  has_paper_trail

  validates :first_name, presence: true
  validates_date :date_of_birth, allow_nil: true, allow_blank: true
  validates_date :test_trace_creation_date, allow_nil: true, allow_blank: true
  validates_date :isolation_start_date, allow_nil: true, allow_blank: true

  scope :search, lambda { |text|
                   where("first_name ilike ?
    or middle_names ilike ?
    or surname ilike ?
    or postcode ilike ?
    or nhs_number ilike ?
    or TO_CHAR(date_of_birth, 'DD/MM/YYYY') ilike ?
    or test_and_trace_account_id ilike ?",
                         "%#{sanitize_sql_like(text)}%",
                         "%#{sanitize_sql_like(text)}%",
                         "%#{sanitize_sql_like(text)}%",
                         "%#{sanitize_sql_like(text)}%",
                         "%#{sanitize_sql_like(text)}%",
                         "%#{sanitize_sql_like(text)}%",
                         "%#{sanitize_sql_like(text)}%")
                 }

  def name
    format_name([first_name, middle_names, surname].join(' '))
  end

  def support_actions_count
    needs.not_assessments.size
  end

  def support_actions_names
    needs.not_assessments.map(&:category).join(', ')
  end

  def assigned_to
    role.id.to_s if role
  end

  def under_18?
    return false if date_of_birth.blank?

    ((Time.zone.now.beginning_of_day - date_of_birth.to_time) / 1.year.seconds).floor < 18
  end

  def valid_telephone_number?
    telephone.nil? || telephone.starts_with?('0') || telephone.starts_with?('+')
  end

  def valid_mobile_number?
    mobile.nil? || mobile.starts_with?('0') || mobile.starts_with?('+')
  end

  private

  def update_telephone
    return if valid_telephone_number?

    self.telephone = telephone.prepend('0')
  end

  def update_mobile
    return if valid_mobile_number?

    self.mobile = mobile.prepend('0')
  end
end
