# frozen_string_literal: true

class RenameTasksToNeeds < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      rename_column :contacts, :tasks_count, :needs_count
      rename_column :contacts, :uncompleted_tasks_count, :uncompleted_needs_count
      rename_column :contacts, :completed_tasks_count, :completed_needs_count

      rename_column :notes, :task_id, :need_id

      rename_table :tasks, :needs
    end
  end
end
