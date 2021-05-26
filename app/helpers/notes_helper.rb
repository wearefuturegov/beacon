# frozen_string_literal: true

module NotesHelper
  # With a move away from how we store categories against notes we
  # needed this helper to maintain backwards compatibility with old
  # categories

  # This is purely a visual aid to improve how older notes look in views
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
