# frozen_string_literal: true

class Contact < ApplicationRecord
  include PgSearch::Model

  has_many :needs, dependent: :destroy
  has_many :uncompleted_needs, -> { uncompleted }, class_name: 'Need'
  has_many :completed_needs, -> { completed }, class_name: 'Need'

  belongs_to :role, foreign_key: 'lead_service_id', optional: true

  has_paper_trail

  validates :first_name, presence: true
  validates :surname, presence: true
  validates_date :date_of_birth, allow_nil: true, allow_blank: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, :if => :email?
  validates :telephone, :numericality => true, :length => { :minimum => 9, :maximum => 11 }, :if => :telephone?
  validates :mobile, :numericality => true, :length => { :minimum => 9, :maximum => 11 }, :if => :mobile?
  validates :channel, :presence => true

  validates_format_of :postcode, :with => /(([A-Z]{1,2}[0-9][A-Z0-9]?|ASCN|STHL|TDCU|BBND|[BFS]IQQ|PCRN|TKCA) ?[0-9][A-Z]{2}|BFPO ?[0-9]{1,4}|(KY[0-9]|MSR|VG|AI)[ -]?[0-9]{4}|[A-Z]{2} ?[0-9]{2}|GE ?CX|GIR ?0A{2}|SAN ?TA1)/, :if => :postcode?

  pg_search_scope :search,
                  against: [:first_name, :surname, :postcode, :nhs_number, :date_of_birth],
                  using: {
                    tsearch: { prefix: true }
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
