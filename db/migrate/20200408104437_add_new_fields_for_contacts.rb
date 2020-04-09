class AddNewFieldsForContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :count_people_in_house, :integer
    add_column :contacts, :any_children_below_15, :boolean
    add_column :contacts, :delivery_details, :text
    add_column :contacts, :any_dietary_requirements, :boolean
    add_column :contacts, :dietary_details, :text
    add_column :contacts, :cooking_facilities, :text
  end
end
