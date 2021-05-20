# frozen_string_literal: true

module NotesHelper
  def notes_category_helper(category)
    categories = {
      general: 'Note',
      phone_success: 'Successful Call',
      phone_message: 'Left Message',
      phone_failure: 'Failed Call',
      phone_import: 'Imported Call Log'
    }
    categories.fetch(category.to_sym, category)
  end
end
