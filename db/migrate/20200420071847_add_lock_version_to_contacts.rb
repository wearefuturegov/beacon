class AddLockVersionToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :lock_version, :integer, default: 0
  end
end
