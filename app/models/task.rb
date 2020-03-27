class Task < ApplicationRecord
  belongs_to :contact
  belongs_to :user

  scope :completed, -> { where.not(completed_on: nil) }
  scope :uncompleted, -> { where(completed_on: nil)  }

  validates :name, presence: true
end
