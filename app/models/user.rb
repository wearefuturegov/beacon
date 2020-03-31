class User < ApplicationRecord
  belongs_to :organisation, optional: true
  has_many :contact_list_users
  has_many :notes
  has_many :contact_lists, through: :contact_list_users
  has_many :contacts, through: :contact_lists
  has_many :tasks, dependent: :destroy
  has_many :assigned_contacts, through: :tasks, source: :contact
  has_many :completed_tasks, -> { completed }, class_name: 'Task'
  has_many :uncompleted_tasks, -> { uncompleted }, class_name: 'Task'
  has_many :uncompleted_contacts, through: :uncompleted_tasks, source: :contact
  has_many :completed_contacts, through: :completed_tasks, source: :contact
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  passwordless_with :email

  has_paper_trail

  def role_title
    admin ? 'Admin' : 'User'
  end

  def name
    [first_name, last_name].join(' ')
  end

  def name_or_email
    name_value = name
    name_value.blank? ? email : name_value
  end
end
