require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:organisation) }
    it { is_expected.to have_many(:contact_list_users) }
    it { is_expected.to have_many(:contact_lists).through(:contact_list_users) }
    it { is_expected.to have_many(:contacts).through(:contact_lists) }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
    it { is_expected.to have_many(:assigned_contacts).through(:tasks).source(:contact) }
    it { is_expected.to have_many(:uncompleted_tasks).conditions(completed_on: nil) }
    it { is_expected.to have_many(:completed_tasks).conditions('completed_on IS NOT NULL') }
    it { is_expected.to have_many(:uncompleted_contacts).through(:uncompleted_tasks).source(:contact) }
    it { is_expected.to have_many(:completed_contacts).through(:completed_tasks).source(:contact) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end
end
