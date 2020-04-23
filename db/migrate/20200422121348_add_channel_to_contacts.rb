class AddChannelToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :channel, :string
  end
end
