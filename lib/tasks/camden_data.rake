require 'csv'
require 'json'

IMPORTED_MSG = 'Imported from before Beacon launch'.freeze

namespace :camden_data do
  desc 'Prepare and import contacts and call log data from Camden'

  task :prepare_contacts, [:healthintent_filepath, :gds_filepath] do |_t, args|
    # Key healthintent data by nhs number to join to gds data
    healthintent_json_rows = []
    CSV.foreach(args.healthintent_filepath, headers: true) do |row|
      # TODO: Is to_json necessary if rails knows it's a jsonb field?
      healthintent_json_rows[row['NHS number']] = row.to_json
    end

    # Update or create a contact for each person in gds data
    CSV.foreach(args.gds_filepath, headers: true) do |row|
      address = concat_address(row)
      date_of_birth = parse_date(row['DOB'])
      gds_json = row.to_json
      healthintent_json = healthintent_json_rows[row['NHSNumber']]

      User.find_or_initialize_by(nhs_number: row['NHSNumber'])
          .update!(first_name: row['FirstName'],
                   middle_names: row['MiddleName'],
                   surname: row['LastName'],
                   address: address,
                   postcode: row['Postcode'],
                   date_of_birth: date_of_birth,
                   telephone: row['Phone'],
                   mobile: row['Mobile'],
                   gds_import_data: gds_json,
                   healthintent_import_data: healthintent_json)
    end
  end

  task :prepare_calls, [:calls_filepath] do |_t, args|
    CSV.foreach(args.calls_filepath, headers: true) do |row|
      user = User.find_by!(camden_shielded_id: row['Shielded ID'])

      need = Need.find_or_initialize_by(user: user, category: 'phone triage',
                                        name: IMPORTED_MSG)
                 .update!

      json_row = row.to_json # TODO: Is to_json necessary if rails knows it's a jsonb field?
      date = parse_date(row['Contact attempted (date)'])
      body = compose_body(row)

      need.notes.find_or_initialize_by(category: 'phone_imported')
          .update!(data: json_row,
                   created_at: date,
                   updated_at: date,
                   body: body)
    end
  end

end

def compose_address(row)
  keys = ['Address1', 'Address2', 'Address3',
          'Address4', 'Address5', 'Postcode']
  values = keys.map { |key| row[key] }
  non_empty_values = values.select { |value| value } # TODO: is identity function necessary?
  non_empty_values.join(', ')
end

def parse_date(value)
  Date.strptime(value, '%d/%m/%Y')
end

def compose_body(row)
  keys_to_omit = ['Shielded ID', 'Contact attempted (date)', 'Time']
  keys = row.keys - keys_to_omit
  non_empty_keys = keys.select { |key| row[key] }
  lines = non_empty_keys.map { |key| "#{key}: #{row[key]}" }
  lines.join("\n")
end
