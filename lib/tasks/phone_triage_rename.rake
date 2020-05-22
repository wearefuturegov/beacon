namespace :upgrade do
  namespace :v3_0_0 do
    desc 'Set the Need.category to Triage if Phone triage'
    task update_triage_category: :environment do
      ActiveRecord::Base.transaction do
        p Need.where(category: 'phone triage').update_all(category: 'triage')
      end
    end
  end
end
