class AddLeadServiceNoteToContact < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :lead_service_note, :string
  end
end
