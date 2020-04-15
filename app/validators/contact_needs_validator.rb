
class ContactNeedsValidator < ActiveModel::Validator
  def validate(contact_needs)
    contact_needs.errors['Phone Triage Scheduled Date'] << 'is invalid'
  end
end