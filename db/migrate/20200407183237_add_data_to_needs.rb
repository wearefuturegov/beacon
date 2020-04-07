class AddDataToNeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :needs, :data, :jsonb
  end
end
