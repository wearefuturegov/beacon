require_relative '../historic_data_cleaner'

namespace :strip_whitespace do
  desc 'Strip whitespace from specified model/table'
  task :data_cleanup, [:object_name, :first_attribute] => :environment do |t, args|
    args.with_defaults(object_name: :unspecified, first_attribute: :unspecified)
    abort 'Missing Arguments! Exiting' if args[:object_name] == :unspecified || args[:first_attribute] == :unspecified

    fields_to_update = [args[:first_attribute]]
    if args.extras.any?
      fields_to_update.push args.extras
    else
      fields_to_update = args[:first_attribute]
    end

    HistoricDataCleaner.call(args[:object_name], t.name, fields_to_update.flatten).cleanse
  end
end
