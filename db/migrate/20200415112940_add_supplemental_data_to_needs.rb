class AddSupplementalDataToNeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :needs, :supplemental_data, :jsonb
  end
end
