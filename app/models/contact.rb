# frozen_string_literal: true

class Contact < ApplicationRecord
  require 'activerecord-import/base'
  require 'activerecord-import/active_record/adapters/postgresql_adapter'
  include Stripable

  before_validation :strip_whitespace_from_all_text_and_strings

  has_many :needs, dependent: :destroy
  has_many :uncompleted_needs, -> { uncompleted }, class_name: 'Need'
  has_many :completed_needs, -> { completed }, class_name: 'Need'

  belongs_to :role, foreign_key: 'lead_service_id', optional: true
  belongs_to :imported_item, optional: true

  has_paper_trail

  validates :first_name, presence: true
  validates_date :date_of_birth, allow_nil: true, allow_blank: true

  scope :search, lambda { |text|
                   where("first_name ilike ?
    or middle_names ilike ?
    or surname ilike ?
    or postcode ilike ?
    or nhs_number ilike ?
    or TO_CHAR(date_of_birth, 'DD/MM/YYYY') ilike ?
    or test_and_trace_account_id ilike ?
    or address ilike ?",
                         "%#{sanitize_sql_like(text)}%",
                         "%#{sanitize_sql_like(text)}%",
                         "%#{sanitize_sql_like(text)}%",
                         "%#{sanitize_sql_like(text)}%",
                         "%#{sanitize_sql_like(text)}%",
                         "%#{sanitize_sql_like(text)}%",
                         "%#{sanitize_sql_like(text)}%",
                         "%#{sanitize_sql_like(text)}%")
                 }

  def name
    [first_name, middle_names, surname].join(' ')
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
end
