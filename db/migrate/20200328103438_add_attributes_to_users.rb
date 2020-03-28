class AddAttributesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email, :text
    add_column :users, :invited, :datetime
    add_column :users, :admin, :boolean
    add_column :users, :last_logged_in, :datetime
  end
end
