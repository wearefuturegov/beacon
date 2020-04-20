class AddCurrentRoleToUser < ActiveRecord::Migration[6.0]

  disable_ddl_transaction!

  def change
    add_reference :users,
                  :role,
                  foreign_key: true,
                  index: { algorithm: :concurrently }
  end
end
