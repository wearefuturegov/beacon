class AddFreePrescriptionsToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :eligible_for_free_prescriptions, :boolean
  end
end
