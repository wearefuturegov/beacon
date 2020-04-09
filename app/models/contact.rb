# frozen_string_literal: true

class Contact < ApplicationRecord
  include PgSearch::Model

  belongs_to :contact_list, optional: true
  has_many :needs, dependent: :destroy
  has_many :uncompleted_needs, -> { uncompleted }, class_name: 'Need'
  has_many :completed_needs, -> { completed }, class_name: 'Need'

  acts_as_ordered_taggable
  has_paper_trail

  jsonb_accessor :data,
                 shielded_id: :string, # Shielded ID
                 nhs_number: :string,  # NHS Number
                 gp_practice_code: :string, # GP Practice Code
                 mosaid_id: :string, # Mosaic ID
                 mosaid_id2: :string, # Mosaic ID2
                 eh_flag: :boolean, # EH Flag
                 eh_team: :string, # EH Team
                 eh_worker: :string, # EH Worker
                 cssw_flag: :boolean, # CSSW Flag
                 cssw_team: :string, # CSSW Team
                 cssw_worker: :string, # CSSW Worker
                 asc_flag: :boolean, # ASC Flag
                 asc_psr: :string, # ASC PSR
                 asc_workers: :string # ASC Allocated Workers

  validates :first_name, presence: true

  pg_search_scope :search, 
    against: [:first_name, :surname, :postcode],
    using: {
      tsearch: { prefix: true }
    }

  def name
    [first_name, surname].join(' ')
  end
end
