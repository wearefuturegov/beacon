class DropContacts < ActiveRecord::Migration[6.0]
  def change
    drop_table :contacts do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.string :postcode
      t.boolean :food
      t.boolean :finances
      t.boolean :pets
      t.boolean :prescriptions
      t.boolean :social
      t.boolean :wellbeing
      t.string :other

      t.timestamps
    end
  end
end
