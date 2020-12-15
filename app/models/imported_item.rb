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

    unique_contacts, not_unique_contacts = unique_and_non_unique_records contacts_rows

    contacts = []
    unique_contacts.each do |contact_record|
      contacts << Contact.new(
        test_and_trace_account_id: contact_record[0],
        nhs_number: contact_record[1],
        is_vulnerable: (contact_record[2] == 1 || contact_record[2].to_s.downcase == 'true'),
        first_name: contact_record[3],
        surname: contact_record[4],
        date_of_birth: contact_record[5],
        email: contact_record[6],
        mobile: contact_record[7],
        telephone: contact_record[8],
        address: contact_record[9],
        postcode: contact_record[10],
        needs: [Need.new(category: 'Check in', start_on: Date.today + 2.days, name: contact_record[11])],
        test_trace_creation_date: contact_record[12],
        isolation_start_date: contact_record[13],
        imported_item: self
      )
    end
    Contact.import! contacts, recursive: true, all_or_none: true
    [unique_contacts, not_unique_contacts]
  end

  private

  def unique_and_non_unique_records(records)
    not_unique_records = []
    unique_records = []
    records.each do |record|
      if check_record(record)
        not_unique_records << record
      else
        unique_records << record
      end
    end
    [unique_records, not_unique_records]
  end

  def check_record(record)
    if not_empty(record[0]) && not_zero(Contact.where('test_and_trace_account_id = ?', record[0].to_s))
      record
    elsif not_empty(record[1]) && not_zero(Contact.where('nhs_number = ?', record[1].to_s))
      record
    elsif not_empty_name(record)
      record
    end
  end

  def not_empty(col)
    !col.nil? && !col.to_s.strip.empty?
  end

  def not_zero(records)
    !records.count.zero?
  end

  def not_empty_name(record)
    not_empty(record[3]) && not_empty(record[4]) && not_zero(Contact.where('lower(first_name) = lower(?) and lower(surname) = lower(?)', record[3], record[4]))
  end
end
