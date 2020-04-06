# frozen_string_literal: true

class AddTasksCountToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :tasks_count, :integer, default: 0

    reversible do |dir|
      dir.up do
        safety_assured do
          execute 'UPDATE contacts SET tasks_count=(SELECT COUNT(1) FROM tasks WHERE tasks.contact_id = contacts.id);'
        end
      end
    end
  end
end
