# frozen_string_literal: true

class CreateContactListUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :contact_list_users do |t|
      t.references :contact_list, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
