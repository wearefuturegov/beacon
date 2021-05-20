# frozen_string_literal: true

class Note < ApplicationRecord
  include Filterable
  acts_as_paranoid without_default_scope: true

  belongs_to :need
  belongs_to :user, optional: true

  #  enum category: { 'Note': 'general',
  #                    'Successful Call': 'phone_success',
  #                    'Left Message': 'phone_message',
  #                    'Failed Call': 'phone_failure',
  #                    'Imported Call Log': 'phone_import' }

  CALL_TITLES = [
    'Adhering to guidance',
    'Advice with traveling',
    'Food banks - signposted',
    'Food banks - reffered',
    'Other'
  ].freeze

  scope :filter_need_not_destroyed, -> { joins(:need).where('needs.deleted_at IS NULL') }
end
