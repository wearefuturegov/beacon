# frozen_string_literal: true

class AddIsUrgentToNeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :needs, :is_urgent, :boolean, default: false
  end
end
