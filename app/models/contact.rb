class Contact < ApplicationRecord
  belongs_to :contact_list, optional: true
  has_many :tasks

  validates :first_name, presence: true
end
