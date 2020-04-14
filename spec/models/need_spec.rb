# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Need, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:contact).counter_cache(true) }
    it { is_expected.to belong_to(:user).optional(true) }
    it { is_expected.to have_many(:notes).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'scopes' do
    let!(:uncompleted_need) { create :need }
    let!(:completed_need) { create :need, :completed }

    it '.uncompleted' do
      expect(described_class.uncompleted[0]).to eq uncompleted_need
    end

    it '.completed' do
      expect(described_class.completed).to eq [completed_need]
    end

    it '.order_by_category invalid' do
      expect(described_class.order_by_category('1==1')).to eq []
    end

    it '.order_by_category ascending' do
      ordered_needs = described_class.order_by_category('ASC')
      expect(ordered_needs.first.category <=> ordered_needs.last.category).to eq(-1)
    end

    it '.order_by_category descending' do
      ordered_needs = described_class.order_by_category('DESC')
      expect(ordered_needs.first.category <=> ordered_needs.last.category).to eq 1
    end
  end

  it { is_expected.to be_versioned }

  it '#status' do
    need1 = build :need, name: 'medicines', completed_on: nil
    expect(need1.status).to eq 'To do'

    need2 = build :need, name: 'food', completed_on: DateTime.now
    expect(need2.status).to eq 'Complete'
  end
end
