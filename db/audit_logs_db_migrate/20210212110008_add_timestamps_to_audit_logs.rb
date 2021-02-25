class AddTimestampsToAuditLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :audit_logs, :created_at, :datetime, null: false
    add_column :audit_logs, :updated_at, :datetime, null: false
  end
end
