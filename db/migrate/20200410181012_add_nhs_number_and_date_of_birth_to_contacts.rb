class AddNhsNumberAndDateOfBirthToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :nhs_number, :string
    add_column :contacts, :date_of_birth, :date
  end
end
