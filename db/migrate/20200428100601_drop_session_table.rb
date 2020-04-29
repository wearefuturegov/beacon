class DropSessionTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :session_table
  end
end
