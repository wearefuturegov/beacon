namespace :cleanup_needs_by_priority do
  desc 'Detele needs and notes records for needs.supplemental_data.food_priority == 3.'
  task food_priority_3: :environment do
    p Need.where('supplemental_data @> ?', { food_priority: '3' }.to_json).destroy_all
  end
end
