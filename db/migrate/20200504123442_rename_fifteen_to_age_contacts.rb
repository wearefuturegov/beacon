class RenameFifteenToAgeContacts < ActiveRecord::Migration[6.0]
  StrongMigrations.disable_check(:rename_column)
  def change
    rename_column :contacts, :any_children_below_15, :any_children_under_age
  end
end
