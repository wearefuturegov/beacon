# frozen_string_literal: true

class Note < ApplicationRecord
  acts_as_paranoid without_default_scope: true
  
  belongs_to :need
  belongs_to :user, optional: true

  enum category: { 'Note': 'general',
                   'Successful Call': 'phone_success',
                   'Left Message': 'phone_message',
                   'Failed Call': 'phone_failure',
                   'Imported Call Log': 'phone_import' }

  validates :body, presence: true

  def self.categories_without_phone_import
    categories.except('Imported Call Log'.to_sym)
  end
  
end
