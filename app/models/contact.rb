# frozen_string_literal: true

class Contact < ApplicationRecord
  include PgSearch::Model

  has_many :needs, dependent: :destroy
  has_many :uncompleted_needs, -> { uncompleted }, class_name: 'Need'
  has_many :completed_needs, -> { completed }, class_name: 'Need'

  belongs_to :role, foreign_key: 'lead_service_id', optional: true

  has_paper_trail

  validates :first_name, presence: true
  validates_date :date_of_birth, allow_nil: true, allow_blank: true

  pg_search_scope :search,
                  against: [:first_name, :surname, :postcode, :nhs_number, :date_of_birth],
                  using: {
                    tsearch: { prefix: true }
                  }

  def name
    [first_name, middle_names, surname].join(' ')
  end

  def assigned_to
    "role-#{role.id}" if role
  end
end
