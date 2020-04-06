# frozen_string_literal: true

class CreateContactsV2 < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :middle_names
      t.string :surname
      t.string :address
      t.string :postcode
      t.string :telephone
      t.string :mobile
      t.jsonb :nhs_import_data
      t.boolean :is_vulnerable

      t.timestamps
    end
  end
end
