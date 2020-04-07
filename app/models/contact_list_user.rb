# frozen_string_literal: true

class ContactListUser < ApplicationRecord
  belongs_to :contact_list
  belongs_to :user
end
