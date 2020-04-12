# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :need
  belongs_to :user, optional: true

  validates :body, presence: true
end
