# frozen_string_literal: true

class AddUserToNote < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    Note.destroy_all # so we don't fail the next step with null user field values
    add_reference :notes, :user, null: false, foreign_key: true, index: { algorithm: :concurrently }
  end
end
