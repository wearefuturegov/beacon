# frozen_string_literal: true

class Contact < ApplicationRecord
  include PgSearch::Model
  self.ignored_columns = ['needs_count', 'uncompleted_needs_count', 'completed_needs_count']

  has_many :needs, dependent: :destroy
  has_many :uncompleted_needs, -> { uncompleted }, class_name: 'Need'
  has_many :completed_needs, -> { completed }, class_name: 'Need'

  has_paper_trail

  validates :first_name, presence: true

  pg_search_scope :search,
                  against: [:first_name, :surname, :postcode, :nhs_number, :date_of_birth],
                  using: {
                    tsearch: { prefix: true }
                  }

  def name
    [first_name, middle_names, surname].join(' ')
  end
end
