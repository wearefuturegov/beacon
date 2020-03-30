require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:contact).counter_cache(true) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'scopes' do
    let!(:uncompleted_task) { create :task }
    let!(:completed_task) { create :task, :completed }

    it '.completed' do
      expect(described_class.uncompleted).to eq [uncompleted_task]
    end

    it '.uncompleted' do
      expect(described_class.completed).to eq [completed_task]
    end
  end

  it { is_expected.to be_versioned }
end
