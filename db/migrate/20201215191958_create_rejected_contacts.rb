class CreateRejectedContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :rejected_contacts do |t|
      t.references :imported_item, null: false, foreign_key: true
      t.string :test_and_trace_account_id
      t.string :nhs_number
      t.boolean :is_vulnerable
      t.string :first_name
      t.string :middle_names
      t.string :surname
      t.date :date_of_birth
      t.text :email
      t.string :mobile
      t.string :telephone
      t.string :address
      t.string :postcode
      t.string :needs
      t.date :test_trace_creation_date
      t.date :isolation_start_date
    end
  end
end
