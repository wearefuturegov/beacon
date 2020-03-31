class AddUserToNote < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_reference :notes, :user, null: false, foreign_key: true, index: {algorithm: :concurrently}
  end
end
