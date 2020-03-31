require_relative '20200329100626_create_notes'

class UpdateNotesReference < ActiveRecord::Migration[6.0]
  def change
    revert CreateNotes

    create_table :notes do |t|
      t.text :body, null: false
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
