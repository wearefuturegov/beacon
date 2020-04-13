class AddImportDataToNotes < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :import_data, :jsonb
  end
end
