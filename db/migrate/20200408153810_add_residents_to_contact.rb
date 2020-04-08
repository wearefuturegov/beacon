class AddResidentsToContact < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :residents_count, :integer, default: 0
    add_column :contacts, :has_children, :boolean, default: false
  end
end
