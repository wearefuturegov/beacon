require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:contact_list).optional(true) }
    it { is_expected.to have_many(:tasks) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :first_name }
  end

  it '.priority' do
    expect(subject)
      .to define_enum_for(:priority)
      .with_values(low: 'low', medium: 'medium', high: 'high')
      .backed_by_column_of_type(:string)
      .with_suffix
  end
end
