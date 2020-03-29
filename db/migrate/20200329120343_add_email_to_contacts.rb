class AddEmailToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :email, :text
  end
end
