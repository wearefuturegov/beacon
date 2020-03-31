class Task < ApplicationRecord
  belongs_to :contact, counter_cache: true
  belongs_to :user, optional: true

  has_paper_trail

  scope :completed, -> { where.not(completed_on: nil) }
  scope :uncompleted, -> { where(completed_on: nil)  }

  counter_culture :contact,
                  column_name: proc { |model| model.completed_on ? 'completed_tasks_count' : 'uncompleted_tasks_count' },
                  column_names: {
                    Task.uncompleted => :uncompleted_tasks_count,
                    Task.completed => :completed_tasks_count
                  }


  validates :name, :due_by, presence: true

  delegate :name, :priority, to: :contact, prefix: true
  delegate :name, to: :user, prefix: true
end
