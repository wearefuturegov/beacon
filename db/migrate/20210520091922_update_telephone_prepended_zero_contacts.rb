class UpdateTelephonePrependedZeroContacts < ActiveRecord::Migration[6.0]
  def change
    Contact.all.each do |contact|
      contact.update(telephone: contact.telephone.prepend('0')) unless contact.valid_telephone_number?

      contact.update(mobile: contact.mobile.prepend('0')) unless contact.valid_mobile_number?
    end
  end
end
