# frozen_string_literal: true

class Role < ApplicationRecord
  alias_attribute :tag, :role

  validates_uniqueness_of :name, :role

  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles
  has_many :needs

  scope :construct_assigned_to_options, -> { order(:name).map { |role| [role.name, "role-#{role.id}"] } }
end
