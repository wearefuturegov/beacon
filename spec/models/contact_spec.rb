# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:needs).dependent(:destroy) }
    it { is_expected.to have_many(:uncompleted_needs).conditions('status <> complete') }
    it { is_expected.to have_many(:completed_needs).conditions(status: :complete) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :first_name }
  end

  it { is_expected.to be_versioned }

  it '#name' do
    contact = build :contact, first_name: 'John', middle_names: 'Ryan', surname: 'Doe'

    expect(contact.name).to eq 'John Ryan Doe'
  end

  it 'validates date of birth with blank date' do
    valid_contact = build :contact, first_name: 'John', middle_names: 'Ryan', surname: 'Doe', date_of_birth: ''
    expect(valid_contact.valid?).to be_truthy
  end

  it 'validates date of birth with date' do
    valid_contact = build :contact, first_name: 'John', middle_names: 'Ryan', surname: 'Doe', date_of_birth: '1/2/1945'
    expect(valid_contact.valid?).to be_truthy
  end

  it 'validates date of birth with invalid date' do
    valid_contact = build :contact, first_name: 'John', middle_names: 'Ryan', surname: 'Doe', date_of_birth: 'abc'
    expect(valid_contact.valid?).to be_falsy
  end

  describe '#strip_whitespace' do
    it 'removes whitespace around fields that respond to the #strip method' do
      valid_contact = create :contact, first_name: '     Marcy', middle_names: 'Sarah Marie ', surname: ' Smith-Williams', date_of_birth: '1/12/1986'
      expect(valid_contact.first_name).to eq 'Marcy'
      expect(valid_contact.middle_names).to eq 'Sarah Marie'
      expect(valid_contact.surname).to eq 'Smith-Williams'
    end
  end
end
