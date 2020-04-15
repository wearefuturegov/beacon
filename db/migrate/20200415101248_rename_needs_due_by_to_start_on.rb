class RenameNeedsDueByToStartOn < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      remove_column :needs, :due_by
      add_column :needs, :start_on, :datetime
    end
  end
end
