# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :need
  belongs_to :user

  validates :body, presence: true
end
