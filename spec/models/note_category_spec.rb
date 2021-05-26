require 'rails_helper'

RSpec.describe NoteCategory, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
