class AllowNullUserOnNotes < ActiveRecord::Migration[6.0]
  def change
    change_column_null :notes, :user_id, true
  end
end
