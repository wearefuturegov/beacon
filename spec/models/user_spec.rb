# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:needs).dependent(:destroy) }
    it { is_expected.to have_many(:notes).dependent(:destroy) }
    it { is_expected.to have_many(:assigned_contacts).through(:needs).source(:contact) }
    it { is_expected.to have_many(:uncompleted_needs).conditions('status <> complete') }
    it { is_expected.to have_many(:completed_needs).conditions(status: :complete) }
    it { is_expected.to have_many(:uncompleted_contacts).through(:uncompleted_needs).source(:contact) }
    it { is_expected.to have_many(:completed_contacts).through(:completed_needs).source(:contact) }
  end

  it { is_expected.to be_versioned }

  it '#name' do
    user = build :user, first_name: 'John', last_name: 'Doe'

    expect(user.name).to eq 'John Doe'
  end

  it '#name_or_email' do
    user1 = build :user, first_name: 'John', last_name: 'Doe'
    expect(user1.name_or_email).to eq 'John Doe'
    user2 = build :user, first_name: '', last_name: '', email: 'jane@gmail.com'
    expect(user2.name_or_email).to eq 'jane@gmail.com'
  end
end
