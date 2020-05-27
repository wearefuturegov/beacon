class CreateImportedItems < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    create_table :imported_items do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :imported_items, :name, unique: true, algorithm: :concurrently
    add_column :contacts, :imported_item_id, :bigint
    add_foreign_key :contacts,
                    :imported_items,
                    column: :imported_item_id,
                    index: { algorithm: :concurrently },
                    validate: false
  end
end
