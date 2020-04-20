class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :role, null: false
      t.timestamps
    end

    create_table :user_roles, :id => false do |t|
      t.references :role, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
    end
  end
end
