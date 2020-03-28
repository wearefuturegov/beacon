class AddPriorityToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :priority, :string
  end
end
