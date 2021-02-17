class RequestDataToAuditLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :audit_logs, :request_data, :jsonb
  end
end
