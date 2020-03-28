class Contact < ApplicationRecord
  belongs_to :contact_list, optional: true
  has_many :tasks

  acts_as_ordered_taggable

  validates :first_name, presence: true
end
