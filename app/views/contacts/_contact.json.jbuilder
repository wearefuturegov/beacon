json.extract! contact, :id, :name, :phone, :address, :postcode, :food, :finances, :pets, :prescriptions, :social, :wellbeing, :other, :created_at, :updated_at
json.url contact_url(contact, format: :json)
