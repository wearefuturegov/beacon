class RenameDataFieldsOnContacts < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      rename_column :contacts, :nhs_import_data, :gds_import_data
      rename_column :contacts, :data, :healthintent_import_data
    end
  end
end
