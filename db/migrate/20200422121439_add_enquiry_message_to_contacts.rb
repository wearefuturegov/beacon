class AddEnquiryMessageToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :enquiry_message, :text
  end
end
