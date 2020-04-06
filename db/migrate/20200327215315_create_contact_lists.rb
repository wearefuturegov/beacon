# frozen_string_literal: true

class CreateContactLists < ActiveRecord::Migration[6.0]
  def change
    create_table :contact_lists do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
