namespace :upgrade do
  namespace :v2_0_0 do
    desc 'Update needs.status based on completed_on'
    task update_needs_statuses: :environment do
      Need.where(completed_on: nil, status: nil).update_all(status: :to_do)
      Need.where(status: nil).where.not(completed_on: nil).update_all(status: :complete)
    end
  end
end
