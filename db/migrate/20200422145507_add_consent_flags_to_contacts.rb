class AddConsentFlagsToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :no_calls_flag, :boolean, default: false
    add_column :contacts, :deceased_flag, :boolean, default: false
    add_column :contacts, :share_data_flag, :boolean
  end
end
