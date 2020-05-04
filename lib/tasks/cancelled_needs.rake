namespace :cancelled_needs do
  desc 'All completed needs with note body (text) containing #NoNeed will be set to cancelled. (the value of note.category will not be taken into account)'
  task update_status: :environment do
    p Need.joins(:notes).where.not(status: :cancelled).where('body ilike ?', '#noneed').update_all(status: :cancelled)
  end
end
