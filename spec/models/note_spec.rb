require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:task) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :body }
  end
end
