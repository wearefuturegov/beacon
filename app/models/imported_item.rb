# frozen_string_literal: true

class ImportedItem < ApplicationRecord
  include Filterable

  require 'csv'

  validates_uniqueness_of :name
  validates :name, presence: true, allow_blank: false
  has_many :contacts

  def import(params) # test
    contacts = []
    CSV.foreach(params[:file].path) do |r|
      contacts << Contact.new(
        first_name: r[0],
        surname: r[1],
        imported_item: self,
        needs: [Need.new(category: 'Triage', start_on: Date.tomorrow, name: 'Imported from CSV')]
      )
    end

    Contact.import! contacts, recursive: true, all_or_none: true
  end
end
