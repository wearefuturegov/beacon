class AddEnquiryReferralToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :enquiry_referral, :boolean, default: false
  end
end
