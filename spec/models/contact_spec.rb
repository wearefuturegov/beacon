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

  it 'validates postcode with invalid postcode' do
    valid_contact = build :contact, first_name: 'John', middle_names: 'Ryan', surname: 'Doe', postcode: 'INVALID'
    expect(valid_contact.valid?).to be_falsy
  end

  it 'validates postcode with valid postcode' do
    valid_contact = build :contact, first_name: 'John', middle_names: 'Ryan', surname: 'Doe', postcode: 'A1 1AA'
    expect(valid_contact.valid?).to be_truthy
  end

  it 'validates phone number when phone number is too long' do
    valid_contact = build :contact, first_name: 'John', middle_names: 'Ryan', surname: 'Doe', telephone: '111111111111'
    expect(valid_contact.valid?).to be_falsey
  end

  it 'validates mobile when mobile is too long' do
    valid_contact = build :contact, first_name: 'John', middle_names: 'Ryan', surname: 'Doe', mobile: '111111111111'
    expect(valid_contact.valid?).to be_falsey
  end

  it 'validates phone number when phone number is too short' do
    valid_contact = build :contact, first_name: 'John', middle_names: 'Ryan', surname: 'Doe', telephone: '11111111'
    expect(valid_contact.valid?).to be_falsey
  end

  it 'validates mobile when mobile is too short' do
    valid_contact = build :contact, first_name: 'John', middle_names: 'Ryan', surname: 'Doe', mobile: '11111111'
    expect(valid_contact.valid?).to be_falsey
  end
end
