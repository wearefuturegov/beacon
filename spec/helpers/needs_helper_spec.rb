# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NeedsHelper do
  describe '#needs' do
    it 'returns a list of needs' do
      expect(helper.needs.count).to be > 0
    end
  end

  describe '#note_category_display' do
    it 'returns appropriate display values when given a note category' do
      [
        ['phone_success', 'Successful Call'],
        ['phone_failure', 'Failed Call'],
        ['phone_message', 'Left Message'],
        %w[note Note]
      ].each do |category_id, display_text|
        expect(helper.note_category_display(category_id)).to be display_text
      end
    end
  end
end
