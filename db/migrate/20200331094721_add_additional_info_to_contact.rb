class AddAdditionalInfoToContact < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :additional_info, :string
  end
end
