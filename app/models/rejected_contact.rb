# frozen_string_literal: true

class RejectedContact < ApplicationRecord
  require 'activerecord-import/base'
  require 'activerecord-import/active_record/adapters/postgresql_adapter'
  include CleanData

  before_validation :strip_whitespace_from_all_text_and_strings

  belongs_to :imported_item, optional: true

  has_paper_trail

  validates_date :date_of_birth, allow_nil: true, allow_blank: true
end