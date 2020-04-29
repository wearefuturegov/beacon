class AddTaskCountColumnsToContacts < ActiveRecord::Migration[6.0]
  class Task < ApplicationRecord
    belongs_to :contact, counter_cache: true

    scope :completed, -> { where.not(completed_on: nil) }
    scope :uncompleted, -> { where(completed_on: nil)  }

    # counter_culture :contact,
    #                 column_name: proc { |model| model.completed_on ? 'completed_tasks_count' : 'uncompleted_tasks_count' },
    #                 column_names: {
    #                   Task.uncompleted => :uncompleted_tasks_count,
    #                   Task.completed => :completed_tasks_count
    #                 }

  end

  def change
    add_column :contacts, :uncompleted_tasks_count, :integer, default: 0
    add_column :contacts, :completed_tasks_count, :integer, default: 0

    # Task.counter_culture_fix_counts
  end
end
