class RemoveContactsNeedsCounters < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      remove_column :contacts, :needs_count, :integer, default: 0
      remove_column :contacts, :uncompleted_needs_count, :integer, default: 0
      remove_column :contacts, :completed_needs_count, :integer, default: 0
    end
  end
end
