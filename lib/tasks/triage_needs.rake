require 'date'

namespace :triage_needs do
  namespace :v2_1_0 do
    desc 'Update needs.start_on based on triage category'
    task update_start_on: :environment do
      ActiveRecord::Base.transaction do
        p Need.where(start_on: nil, category: 'phone triage').update_all(start_on: DateTime.now)
      end
    end
  end
end
