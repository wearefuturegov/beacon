# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :organisation, optional: true
  has_many :contact_list_users
  has_many :notes, dependent: :destroy
  has_many :contact_lists, through: :contact_list_users
  has_many :contacts, through: :contact_lists
  has_many :needs, dependent: :destroy
  has_many :assigned_contacts, through: :needs, source: :contact
  has_many :completed_needs, -> { completed }, class_name: 'Need'
  has_many :uncompleted_needs, -> { uncompleted }, class_name: 'Need'
  has_many :uncompleted_contacts, through: :uncompleted_needs, source: :contact
  has_many :completed_contacts, through: :completed_needs, source: :contact
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  belongs_to :role, optional: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  passwordless_with :email

  has_paper_trail

  def role_names
    roles.map(&:name).join(', ')
  end

  def name
    [first_name, last_name].join(' ')
  end

  def name_or_email
    name_value = name
    name_value.blank? ? email : name_value
  end

  def last_logged_in
    passwordless_sessions.try(:last).try(:claimed_at)
  end

  def role_type
    role&.role
  end

  def in_role?(role_id)
    roles.any? { |r| r.id == role_id }
  end

  def in_role_name?(role_name)
    role.role == role_name
  end

  def in_role_names?(role_names)
    role_names.include? role.role
  end
end
