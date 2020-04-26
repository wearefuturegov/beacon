class AddTypeToNeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :needs, :type, :string
  end
end
