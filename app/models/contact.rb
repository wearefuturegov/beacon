class Contact < ApplicationRecord
  belongs_to :contact_list, optional: true
  has_many :tasks

  acts_as_ordered_taggable

  validates :first_name, presence: true

  enum priority: { low: 'low', medium: 'medium', high: 'high' }, _suffix: true

  def name
    [first_name, surname].join(' ')
  end
end
