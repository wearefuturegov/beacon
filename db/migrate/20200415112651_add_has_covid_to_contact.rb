class AddHasCovidToContact < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :has_covid, :boolean
  end
end
