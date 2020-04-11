# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :need
  belongs_to :user

  enum category: { 'Note': 'note',
                   'Successful Call': 'phone_success',
                   'Left Message': 'phone_message',
                   'Failed Call': 'phone_failure' }

  validates :body, presence: true
end
