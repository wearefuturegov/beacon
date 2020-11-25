class AddTestAndTraceAccountIdToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :test_and_trace_account_id, :string
  end
end
