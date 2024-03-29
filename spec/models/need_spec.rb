# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Need, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user).optional(true) }
    it { is_expected.to have_many(:notes).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'scopes' do
    let!(:uncompleted_need) { create :need, status: :to_do }
    let!(:completed_need) { create :need, status: :complete }

    it '.uncompleted' do
      expect(described_class.uncompleted[0]).to eq uncompleted_need
    end

    it '.completed' do
      expect(described_class.completed).to eq [completed_need]
    end
  end

  describe 'orders' do
    let!(:completed_need_first) { create :need, status: :complete, completed_on: DateTime.yesterday }
    let!(:completed_need_second) { create :need, status: :complete, completed_on: DateTime.tomorrow }

    it '.order_by_completed_on asc' do
      expect(described_class.order_by_completed_on(:asc)).to eq [completed_need_first, completed_need_second]
    end

    it '.order_by_completed_on desc' do
      expect(described_class.order_by_completed_on(:desc)).to eq [completed_need_second, completed_need_first]
    end
  end

  it { is_expected.to be_versioned }

  it '#default status' do
    need1 = build :need, name: 'medicines'
    expect(need1.status).to eq 'to_do'
  end

  it '#status' do
    need1 = build :need, name: 'medicines', status: 'to_do'
    expect(need1.completed_on).to be_nil
    expect(need1.status_label).to eq 'To do'

    need2 = create :need, name: 'medicines', status: 'complete'
    expect(need2.completed_on.to_date).to eql(DateTime.now.to_date)
    expect(need2.status_label).to eq 'Complete'

    need3 = build :need, name: 'medicines', status: 'in_progress'
    expect(need3.completed_on).to be_nil
    expect(need3.status_label).to eq 'In progress'

    need4 = build :need, name: 'medicines', status: 'blocked'
    expect(need4.completed_on).to be_nil
    expect(need4.status_label).to eq 'Blocked'

    need5 = build :need, name: 'medicines', status: 'cancelled'
    expect(need5.completed_on).to be_nil
    expect(need5.status_label).to eq 'Cancelled'
  end

  describe 'assing user or team at the same moment' do
    let(:user) { create :user }
    let(:role) { create :role }

    it 'update need with user and role at the same time' do
      need = create :need, name: 'medicines'
      need.update user: user, role: role

      expect(need.user).to be user
      expect(need.role).to be_nil
    end

    it 'update need with role to have user' do
      need = create :need, name: 'medicines', role: role
      need.update user: user

      expect(need.user).to be user
      expect(need.role).to be_nil
    end

    it 'update need with user to have role' do
      need = create :need, name: 'medicines', user: user
      need.update role: role

      expect(need.user).to be_nil
      expect(need.role).to be_role
    end
  end
end
