class User < ApplicationRecord
  belongs_to :organisation, optional: true
  has_many :contact_list_users
  has_many :contact_lists, through: :contact_list_users
  has_many :contacts, through: :contact_lists
  has_many :tasks, dependent: :destroy
  has_many :assigned_contacts, through: :tasks, source: :contact
  has_many :completed_tasks, -> { completed }, class_name: 'Task'
  has_many :uncompleted_tasks, -> { uncompleted }, class_name: 'Task'
  has_many :uncompleted_contacts, through: :uncompleted_tasks, source: :contact
  has_many :completed_contacts, through: :completed_tasks, source: :contact
  validates :email, presence: true

  def role_title
    admin ? 'Admin' : 'User'
  end

  def self.find_or_create_with_auth(auth)
    User.where(:email => auth.info.email).first || User.create_with_auth(auth)
  end

  def self.create_with_auth(auth)
    create! do |user|
      user.email = auth.info.email
      user.invited = Time.now
    end
  end
end
