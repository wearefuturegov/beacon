require 'rails_helper'

RSpec.describe ContactListUser, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:contact_list) }
    it { is_expected.to belong_to(:user) }
  end
end
