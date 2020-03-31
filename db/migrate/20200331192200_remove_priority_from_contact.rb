class RemovePriorityFromContact < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :contacts, :priority, :string }
  end
end
