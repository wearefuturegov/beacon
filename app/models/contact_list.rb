# frozen_string_literal: true

class ContactList < ApplicationRecord
  has_many :contacts
  has_many :contact_list_users
  has_many :users, through: :contact_list_users

  validates :name, presence: true
end
