class AddUniqueIndexToRoles < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :roles, :name, unique: true, algorithm: :concurrently
    add_index :roles, :role, unique: true, algorithm: :concurrently
  end
end
