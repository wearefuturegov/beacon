class AddContactListIdToContacts < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_reference :contacts,
                  :contact_list,
                  foreign_key: true,
                  index: { algorithm: :concurrently }
  end
end
