class AddImportCountAndFailedCountAndUseridToImportedItems < ActiveRecord::Migration[6.0]
  def change
    add_column :imported_items, :imported, :integer
    add_column :imported_items, :failed, :integer
    add_column :imported_items, :uploaded_by_user_id, :bigint
  end
end
