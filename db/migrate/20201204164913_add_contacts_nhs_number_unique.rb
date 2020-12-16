class AddContactsNhsNumberUnique < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def up
    safety_assured { execute 'create unique index index_contacts_on_lower_nhs_number on contacts using btree (lower(nhs_number))' }
  end

  def dow
    safety_assured { execute 'drop index index_contacts_on_lower_nhs_number' }
  end
end
