class AddNoteTypeToNote < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :note_type, :string, default: 'generic'
  end
end
