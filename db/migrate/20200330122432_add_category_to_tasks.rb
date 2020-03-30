class AddCategoryToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :category, :string
    change_column_null :tasks, :user_id, true
    safety_assured do
      execute 'ALTER TABLE "tasks" ADD CONSTRAINT "tasks_due_by_null" CHECK ("due_by" IS NOT NULL) NOT VALID'
    end
  end
end
