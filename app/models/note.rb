# frozen_string_literal: true

class Note < ApplicationRecord
  include Filterable
  acts_as_paranoid without_default_scope: true

  belongs_to :need
  belongs_to :user, optional: true

  CALL_TITLES = [
    'Advice & Guidance',
    'Welfare & Benefits',
    'Emergency Financial Support',
    'Food Support & Vouchers',
    'Business & Business Grants',
    'Vaccination & Vaccination Bus Enquiries',
    'CEV Referral',
    'Test & Trace Outbound Call',
    'Test & Trace Support Payment',
    'LFT & PCR Testing',
    'Other (Specify)'
  ].freeze

  scope :filter_need_not_destroyed, -> { joins(:need).where('needs.deleted_at IS NULL') }
end
