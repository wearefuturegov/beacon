class AuditLog < ApplicationRecord
  connects_to database: { writing: :audit_logs_db }
end