class AddLeadServiceToContact < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :contacts, :lead_service_id, :bigint
    add_foreign_key :contacts,
                    :roles,
                    column: :lead_service_id,
                    index: { algorithm: :concurrently },
                    validate: false
  end
end
