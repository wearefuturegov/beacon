# frozen_string_literal: true

class Note < ApplicationRecord
  include Filterable
  acts_as_paranoid without_default_scope: true

  belongs_to :need
  belongs_to :user, optional: true

  CALL_TITLES = [
    'Advice and Guidance',
    'Welfare and Benefits',
    'Emergency Financial Support',
    'Food Support & Vouchers',
    'Business & Business Grants',
    'Vaccination and Vaccination Bus Enquiries',
    'CEV Referral',
    'Test & Trace Outbound Call',
    'Test & Trace Support Payment',
    'LFT and PCR Testing',
    'Other (Specify)'
  ].freeze

  scope :filter_need_not_destroyed, -> { joins(:need).where('needs.deleted_at IS NULL') }
end
