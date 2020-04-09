# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NeedsHelper  do
  describe '#needs' do
    it 'returns a list of needs' do
      expect(helper.needs.count).to be > 0
    end
  end

  describe '#note_category_display' do
    it 'returns appropriate display values when given a need category and a note category' do
      expect(helper.note_category_display('phone triage','phone_success')).to be 'Successful Phone call'
    end
  end
end