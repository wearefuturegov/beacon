namespace :strip_whitespace do
  desc 'Strip whitespace from specified historic Contact entrys (one off task)'
  task data_cleanup: :environment do
    BATCH_SIZE = 1000
    # Process in batches set by the batch size 1000 is default.
    Contact.find_in_batches(batch_size: BATCH_SIZE) do |contact|
      puts contact.size
      contact.each do |contact_to_update|
        contact_to_update.save(touch: false)
      end
    end
  end
end
