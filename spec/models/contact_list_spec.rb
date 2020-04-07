# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactList, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:contacts) }
    it { is_expected.to have_many(:contact_list_users) }
    it { is_expected.to have_many(:users).through(:contact_list_users) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
