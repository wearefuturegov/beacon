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
  end

  it { is_expected.to be_versioned }

  it '#status' do
    need1 = build :need, name: 'medicines', status: :to_do
    expect(need1.status_label).to eq 'To do'
  end

  describe 'sort_created_and_start_date' do
    let!(:created_today_started) { build :need, name: 'created today, no start date', created_at: DateTime.now, start_on: nil }
    let!(:created_tomorrow_started) { build :need, name: 'created tomorrow, no start date', created_at: DateTime.now + 1.days, start_on: nil }

    let!(:created_today_start_tomorrow) { build :need, name: 'created today, start tomorrow', created_at: DateTime.now, start_on: DateTime.now + 1.days }
    let!(:created_today_start_today) { build :need, name: 'created today, start today', created_at: DateTime.now.beginning_of_day, start_on: DateTime.now.beginning_of_day }

    it 'sorts needs started in the future to be at the end' do
      needs = [created_tomorrow_started, created_today_start_tomorrow].sort { |a, b| Need.sort_created_and_start_date(a, b) }

      expect(needs[0].name).to eq 'created tomorrow, no start date'
      expect(needs[1].name).to eq 'created today, start tomorrow'
    end

    it 'sorts needs by created date when they have no start date' do
      needs = [created_tomorrow_started, created_today_started].sort { |a, b| Need.sort_created_and_start_date(a, b) }

      expect(needs[0].name).to eq 'created today, no start date'
      expect(needs[1].name).to eq 'created tomorrow, no start date'
    end

    # given two needs, one which has a start date before now, the sorting should ignore the start date
    # and sort by created date instead
    it 'sorts needs by created date when they are started' do
      needs = [created_tomorrow_started, created_today_start_today].sort { |a, b| Need.sort_created_and_start_date(a, b) }

      expect(needs[0].name).to eq 'created today, start today'
      expect(needs[1].name).to eq 'created tomorrow, no start date'
    end
  end
end
