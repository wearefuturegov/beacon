class AddDeletedAtToNeeds < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :needs, :deleted_at, :datetime
    add_index :needs, :deleted_at, algorithm: :concurrently
  end
end
