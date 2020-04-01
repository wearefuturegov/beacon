class Note < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :body, presence: true
end
