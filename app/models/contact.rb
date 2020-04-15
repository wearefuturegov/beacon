# frozen_string_literal: true

class Contact < ApplicationRecord
  include PgSearch::Model

  belongs_to :contact_list, optional: true
  has_many :needs, dependent: :destroy
  has_many :uncompleted_needs, -> { uncompleted }, class_name: 'Need'
  has_many :completed_needs, -> { completed }, class_name: 'Need'

  acts_as_ordered_taggable
  has_paper_trail

  jsonb_accessor :healthintent_import_data,
                 mosaic_id: [:string, store_key: 'Mosaic ID'],
                 known_to_asc?: [:boolean, store_key: 'ASC Flag'],
                 linked_phones: [:string, store_key: 'Additona Phone Nuumbers (LBC Sources)'.to_sym]

  validates :first_name, presence: true

  pg_search_scope :search,
                  against: [:first_name, :surname, :postcode],
                  using: {
                    tsearch: { prefix: true }
                  }

  def name
    [first_name, middle_names, surname].join(' ')
  end
end
