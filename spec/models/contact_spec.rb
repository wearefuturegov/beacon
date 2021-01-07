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

  describe '#under_18?' do
    before do
      freeze_time
    end

    after do
      unfreeze_time
    end

    it 'true when dob 18/12/2010' do
      under_18_contact = build :contact, date_of_birth: Date.new(2010, 12, 18)
      expect(under_18_contact.under_18?).to be_truthy
    end

    it 'false when dob 15/01/1989' do
      over_18_contact = build :contact, date_of_birth: Date.new(1989, 0o1, 15)
      expect(over_18_contact.under_18?).to be_falsy
    end
  end
end
