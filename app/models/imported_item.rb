# frozen_string_literal: true

class ImportedItem < ApplicationRecord
  include Filterable
  
  validates_uniqueness_of :name
  has_many :contacts
end