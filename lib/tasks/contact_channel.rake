namespace :upgrade do
  namespace :v2_0_0 do
    desc 'Set the contacts.channel to imported if null'
    task update_contacts_channel: :environment do
      ActiveRecord::Base.transaction do
        Contact.where(channel: nil).update_all(channel: 'imported')
      end
    end
  end
end
