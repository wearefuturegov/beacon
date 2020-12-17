class AddImportCountAndFailedCountAndUseridToImportedItems < ActiveRecord::Migration[6.0]
  def change
    add_column :imported_items, :imported, :integer
    add_column :imported_items, :rejected, :integer
  end

  add_reference :imported_items, :user, foreign_key: true, index: { algorithm: :concurrently }
end
