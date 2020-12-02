# frozen_string_literal: true

class ImportedItem < ApplicationRecord
  include Filterable

  require 'roo'

  validates_uniqueness_of :name
  validates :name, presence: true, allow_blank: false
  has_many :contacts

  def import(params)
    contacts = []
    contacts_rows = []
    Roo::Spreadsheet.open(params[:file].path).each_with_index do |row, idx|
      next if idx.zero?

      contacts << Contact.new(
        test_and_trace_account_id: row[0],
        nhs_number: row[1],
        is_vulnerable: (row[2] == 1 || row[2].to_s&.downcase == 'true'),
        first_name: row[3],
        surname: row[4],
        date_of_birth: row[5],
        email: row[6],
        mobile: row[7],
        telephone: row[8],
        address: row[9],
        postcode: row[10],
        needs: [Need.new(category: 'Check in', start_on: Date.today + 2.days, name: row[11])],
        imported_item: self
      )

      contacts_rows << row
    end

    unique_records contacts_rows
    Contact.import! contacts, recursive: true, all_or_none: true
  end

  private

  def unique_records(rows)
    not_unique_records = []
    rows.each do |row|
      result = check_row(row)
      not_unique_records << result if result
    end
    raise Exceptions::NotUniqueRecord, not_unique_records unless not_unique_records.empty?
  end

  def check_row(row)
    if not_empty(row[0]) && not_zero(Contact.where('test_and_trace_account_id = ?', row[0].to_s))
      row
    elsif not_empty(row[1]) && not_zero(Contact.where('nhs_number = ?', row[1].to_s))
      row
    elsif not_empty(row[6]) && not_zero(Contact.where('email = ?', row[6]))
      row
    end
  end

  def not_empty(col)
    !col.nil? && !col.to_s.strip.empty?
  end

  def not_zero(records)
    !records.count.zero?
  end
end
