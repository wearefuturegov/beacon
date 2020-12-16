class AddReasonToRejectedContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :rejected_contacts, :reason, :string
  end
end
