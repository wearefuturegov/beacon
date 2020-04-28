class RemoveEnquiryFieldsFromContact < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      remove_column :contacts, :enquiry_referral, :boolean
      remove_column :contacts, :enquiry_message, :text
    end
  end
end
