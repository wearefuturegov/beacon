# frozen_string_literal: true

class IndexContactsOnPriority < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :contacts, :priority, algorithm: :concurrently
  end
end
