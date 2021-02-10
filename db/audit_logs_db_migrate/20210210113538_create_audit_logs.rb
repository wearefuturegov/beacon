class CreateAuditLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :audit_logs do |t|
      t.integer :user_id
      t.text :message
    end
  end
end
