class NoteCategory < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
