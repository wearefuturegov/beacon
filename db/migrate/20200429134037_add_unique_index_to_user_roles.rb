class AddUniqueIndexToUserRoles < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :user_roles, [:role_id, :user_id], unique: true, algorithm: :concurrently
  end
end
