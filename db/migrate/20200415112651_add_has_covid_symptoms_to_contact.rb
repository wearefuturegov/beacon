class AddHasCovidSymptomsToContact < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :has_covid_symptoms, :boolean
  end
end
