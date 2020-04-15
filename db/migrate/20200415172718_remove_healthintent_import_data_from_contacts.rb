class RemoveHealthintentImportDataFromContacts < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      remove_column :contacts, :healthintent_import_data, :jsonb
    end
  end
end
