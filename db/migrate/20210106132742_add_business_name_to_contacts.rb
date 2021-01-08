class AddBusinessNameToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :business_name, :string
  end
end
