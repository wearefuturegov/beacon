# frozen_string_literal: true

class ImportedItem < ApplicationRecord
  include Filterable

  require 'roo'

  validates_uniqueness_of :name
  validates :name, presence: true, allow_blank: false
  has_many :contacts

  def import(params)
    contacts_rows = []
    Roo::Spreadsheet.open(params[:file].path).each_with_index do |row, idx|
      next if idx.zero?

      contacts_rows << row
    end

    unique_contacts, not_unique_contacts = unique_records contacts_rows

    contacts = []
    unique_contacts.each do |row|
      contacts << Contact.new(
        test_and_trace_account_id: row[0].strip,
        nhs_number: row[1].strip,
        is_vulnerable: (row[2] == 1 || row[2].to_s.downcase == 'true'),
        first_name: row[3].strip,
        surname: row[4].strip,
        date_of_birth: row[5],
        email: row[6].strip,
        mobile: row[7],
        telephone: row[8],
        address: row[9].strip,
        postcode: row[10].strip,
        needs: [Need.new(category: 'Check in', start_on: Date.today + 2.days, name: row[11])],
        imported_item: self
      )
    end
    Contact.import! contacts, recursive: true, all_or_none: true
    [unique_contacts, not_unique_contacts]
  end

  private

  def unique_records(rows)
    not_unique_records = []
    unique_records = []
    rows.each do |row|
      if check_row(row)
        not_unique_records << row
      else
        unique_records << row
      end
    end
    [unique_records, not_unique_records]
  end

  def check_row(row)
    if not_empty(row[0]) && not_zero(Contact.where('test_and_trace_account_id = ?', row[0].to_s))
      row
    elsif not_empty(row[1]) && not_zero(Contact.where('nhs_number = ?', row[1].to_s))
      row
    elsif not_empty_name(row)
      row
    end
  end

  def not_empty(col)
    !col.nil? && !col.to_s.strip.empty?
  end

  def not_zero(records)
    !records.count.zero?
  end

  def not_empty_name(row)
    not_empty(row[3]) && not_empty(row[4]) && not_zero(Contact.where('first_name = ? and surname = ?', row[3], row[4]))
  end
end
