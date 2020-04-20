namespace :db do
  namespace :drop do
    task connections: :environment do
      begin
        database = ActiveRecord::Base.connection.current_database
        ActiveRecord::Base.connection.execute(<<-SQL)
          SELECT pg_terminate_backend(pg_stat_activity.pid)
          FROM pg_stat_activity
          WHERE pg_stat_activity.datname = '#{database}' AND pid <> pg_backend_pid();
        SQL
      rescue ActiveRecord::NoDatabaseError
        # Do nothing
      end
    end
  end
end