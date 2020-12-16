class AddTestTraceCreationDateAndIsolationStartDateToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :test_trace_creation_date, :date
    add_column :contacts, :isolation_start_date, :date
  end
end
