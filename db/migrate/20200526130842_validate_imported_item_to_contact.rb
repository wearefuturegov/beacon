class ValidateImportedItemToContact < ActiveRecord::Migration[6.0]
  def change
    validate_foreign_key :contacts, :imported_items
  end
end
