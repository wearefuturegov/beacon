class DropContactListsAndOrganisations < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      remove_reference :contacts, :contact_list,
                       index: true, foreign_key: true

      remove_reference :users, :organisation,
                       index: true, foreign_key: true

      drop_table :contact_list_users
      drop_table :contact_lists
      drop_table :organisations
    end
  end
end
