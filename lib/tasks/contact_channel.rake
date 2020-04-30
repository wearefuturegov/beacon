namespace :upgrade do
  namespace :v1_2 do
    desc 'Set the contacts.channel to imported if null'
    task update_contacts_channel: :environment do
      Contact.where(channel: nil).update_all(channel: 'imported')
    end
  end
end
