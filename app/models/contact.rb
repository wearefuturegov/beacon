class Contact < ApplicationRecord
  belongs_to :contact_list, optional: true
  has_many :tasks, dependent: :destroy
  has_many :uncompleted_tasks, -> { uncompleted }, class_name: 'Task'
  has_many :completed_tasks, -> { completed }, class_name: 'Task'

  acts_as_ordered_taggable
  has_paper_trail

  validates :first_name, presence: true

  def name
    [first_name, surname].join(' ')
  end
end
