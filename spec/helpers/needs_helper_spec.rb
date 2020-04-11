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
      display_texts = ['Note', 'Successful Call', 'Left Message', 'Failed Call']
      Note.categories.each.with_index do |category, index|
        expect(helper.note_category_display(category)).to eq display_texts[index]
      end
    end
  end

  describe '#note_category_id' do
    it 'returns appropriate id values when given a note category' do
      ids = %w[note phone_success phone_message phone_failure]
      Note.categories.each.with_index do |category, index|
        expect(helper.note_category_id(category)).to eq ids[index]
      end
    end
  end
end
