class ValidateAddLeadServiceToContact < ActiveRecord::Migration[6.0]
  def change
    validate_foreign_key :contacts, :roles
  end
end
