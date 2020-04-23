class AddStatusToNeeds < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!
  def change
    add_column :needs, :status, :string
    add_index :needs, :status, algorithm: :concurrently
  end
end
