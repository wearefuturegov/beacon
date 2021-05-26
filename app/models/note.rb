# frozen_string_literal: true

class Note < ApplicationRecord
  include Filterable
  acts_as_paranoid without_default_scope: true

  belongs_to :need
  belongs_to :user, optional: true

  CALL_TITLES = [
    'Advice and Guidance',
    'Welfare and Benefits',
    'Emergency financial support',
    'Food Support & Vouchers',
    'Business & Business Grants',
    'Vaccination',
    'CEV Referral',
    'Test & Trace Outbound Call',
    'Other (Specify)'
  ].freeze

  scope :filter_need_not_destroyed, -> { joins(:need).where('needs.deleted_at IS NULL') }
end
