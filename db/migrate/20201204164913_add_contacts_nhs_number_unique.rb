class AddContactsNhsNumberUnique < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!
  def change
    add_index :contacts, :nhs_number, unique: true, algorithm: :concurrently
  end
end
