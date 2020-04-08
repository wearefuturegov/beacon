class AddCategoryToNotes < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :category, :string
  end
end
