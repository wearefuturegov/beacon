# frozen_string_literal: true

SAMPLE_VALUES = {
  'Contact attempted (date)': [
    '04/09/2019'
  ],
  'Time': [
    'eleven ten',
    'Twelve',
    'Two',
    'Two ten',
    'two forty five',
    '12,10',
    '14,08',
    '13,59'
  ],
  'Contact sucessful': [
    'Yes',
    'yes',
    'No 3 Attempts made',
    'No 2 attempts made',
    'No -1 attempt made'
  ],
  'Outcome': [
    'No answer',
    'No support needed',
    'Food and Other referral',
    'Food referral',
    'Other referral'
  ],
  'If no support needed, what support are they getting?': [
    'family',
    'left message',
    'Family',
    'Has had one food bag needs another before Easter',
    'Carer is finding is too hard to get food.'
  ],
  'Food Requirements Priority': [
    'Priority 1',
    'Priority 2',
    'Priority 3'
  ],
  'Book weekly food delivery': [
    true,
    false
  ],
  'Date to call resident back - 6 days from data of call': [
    'See Column A',
    'Not needed',
    '11/04/2019',
    '12/04/2019'
  ],
  'how many people in household?': [
    '0',
    '1',
    '1 adult',
    '2',
    '2 (mentions son but not sure if living there)',
    '2 adults',
    '2 adults and one 4 year old',
    '3 people son 3yr old and mum',
    '4 adults',
    '7',
    'alone',
    'I adult',
    'lives with elderly mother'
  ],
  'Do you have any special dietary requirements?': [
    'allergic to dairy',
    'evaporated milk',
    'fresh green veg',
    'halal',
    'no',
    'No',
    'no fish',
    'no soup',
    'Vegetarian',
    'Yes'
  ],
  'Delivery contact details if different?': [
    'mobile',
    '02081231231 intercom',
    'the number 4 buzzer ring it 3 times please'
  ],
  'Are you or anyone in your home showing any symptoms of COVID-19?': [
    true,
    false
  ],
  'Adult Social Care': nil,
  'Children Services': nil,
  'Mental Wellbeing Referral': nil,
  'Medication/ prescriptions': [
    'needs help collecting medication',
    'Sorted',
    'Need to pick up prescription from Pharmacy but not urgent',
    'Volunteers picking up for him'
  ],
  'Medical appointment Transport': [
    'Yes',
    'May need help in future'
  ],
  'Befriending': nil,
  'Additional Shopping Requests': [
    'dog food',
    'toiletries basic'
  ],
  'Housing/ Waste Disposal': nil,
  'Other referrals (eg concerns for neighbour/friend)': [
    'Asthma sufferer',
    'Concerned for a friend and neighbour. John Doe 02081234567',
    'Please discontinue food delivery as no longer required'
  ],
  'Miscellaneous Other': [
    'Answer phone, left message',
    'left voicemail with support line',
    'no voicemail option'
  ],
  'Miscellaneous Other2': [
    'Left answer phone message',
    'Left message on mobile',
    "can't get delivery",
    'slots are always booked'
  ],
  'Have you told resident about the 24/7 Council Covid 19 support line and website?': [
    'Yes',
    'yes',
    'No',
    'no has it already',
    'Yes was already called'
  ]
}.freeze

def generate_import_data
  import_data = {
    'Shielded ID': Faker::Number.between(from: 1, to: 2500).to_s
  }

  SAMPLE_VALUES.each do |key, values|
    import_data[key] = [*values, nil].sample
  end

  import_data
end

def compose_body(import_data)
  keys_to_omit = [
    'Shielded ID'.to_sym,
    'Contact attempted (date)'.to_sym,
    'Time'.to_sym
  ]
  body_data = import_data.reject { |key, value| keys_to_omit.include?(key) || value.nil? }
  lines = body_data.keys.map { |key| "#{key}: #{body_data[key]}" }
  lines.join("\n")
end

FactoryBot.define do
  factory :imported_note, parent: :note do
    user { nil }
    category { 'phone_import' }
    import_data { generate_import_data }
    body { compose_body(import_data) }
  end
end
