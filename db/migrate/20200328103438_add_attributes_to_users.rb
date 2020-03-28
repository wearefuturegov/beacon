class AddAttributesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email, :text, null: false
    add_column :users, :invited, :datetime, null: false
    add_column :users, :admin, :boolean, null: false, default: false
    add_column :users, :last_logged_in, :datetime

    change_column_null :users, :first_name, true
    change_column_null :users, :last_name, true
    change_column_null :users, :organisation_id, true
  end
end
