# frozen_string_literal: true

class User < ApplicationRecord
  has_many :notes, dependent: :destroy
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

  scope :with_role, ->(role_id) { joins(:user_roles).where(user_roles: { role_id: role_id }) }
  scope :name_order, -> { order(:first_name, :last_name) }

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

  def assign_role_if_empty
    self.role = roles.first if role.nil?
    raise Exceptions::NoValidRoleError if role.nil?
  end
end
