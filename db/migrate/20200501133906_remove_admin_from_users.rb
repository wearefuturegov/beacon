class RemoveAdminFromUsers < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      remove_column :users, :admin, :bool, default: false
    end
  end
end
