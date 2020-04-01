require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:contact_list).optional(true) }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
    it { is_expected.to have_many(:uncompleted_tasks).conditions(completed_on: nil) }
    it { is_expected.to have_many(:completed_tasks).conditions('completed_on IS NOT NULL') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :first_name }
  end

  it { is_expected.to be_versioned }

  it '#name' do
    contact = build :contact, first_name: 'John', surname: 'Doe'

    expect(contact.name).to eq 'John Doe'
  end
end
