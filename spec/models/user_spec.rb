# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:needs) }
    it { is_expected.to have_many(:notes) }
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

  it '#name when deleted' do
    user = build :user, first_name: 'Rob', last_name: 'Jones', deleted_at: DateTime.now

    expect(user.name).to eq 'Rob Jones [X]'
  end

  it '#name_or_email' do
    user1 = build :user, first_name: 'John', last_name: 'Doe'
    expect(user1.name_or_email).to eq 'John Doe'
    user2 = build :user, first_name: '', last_name: '', email: 'jane@gmail.com'
    expect(user2.name_or_email).to eq 'jane@gmail.com'
  end

  it 'scope name order' do
    user1 = create :user, first_name: 'Aaron', last_name: 'Abbe'
    user2 = create :user, first_name: 'Caden', last_name: 'Abbe'
    user3 = create :user, first_name: 'Aaron', last_name: 'Baye'
    user4 = create :user, first_name: 'Babs', last_name: 'Abbe'

    expect(described_class.name_order).to eq [user1, user3, user4, user2]
  end
end
