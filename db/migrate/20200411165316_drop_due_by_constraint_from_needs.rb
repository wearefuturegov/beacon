class DropDueByConstraintFromNeeds < ActiveRecord::Migration[6.0]
  def change
    # Reverses a hard-coded constraint from 20200408110351_add_category_to_notes
    safety_assured do
      execute 'ALTER TABLE "needs" DROP CONSTRAINT "tasks_due_by_null"'
    end
  end
end
