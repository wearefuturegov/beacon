module NeedCsv
  extend ActiveSupport::Concern
  class_methods do
    def to_csv
      attributes = {
        id: 'need_id',
        category: 'category',
        status: 'status',
        created_at: 'created_at',

        contact_name: 'name',
        contact_address: 'address',
        contact_postcode: 'postcode',
        contact_telephone: 'telephone',
        contact_mobile: 'mobile',

        name: 'description',
        food_priority: 'food_priority',
        food_service_type: 'food_service_type',
        contact_count_people_in_house: 'count_people_in_house',
        contact_any_dietary_requirements: 'any_dietary_requirements',
        contact_dietary_details: 'dietary_details',
        contact_cooking_facilities: 'cooking_facilities',
        contact_delivery_details: 'delivery_details',
        contact_has_covid_symptoms: 'has_covid_symptoms',

        contact_is_vulnerable: 'is_vulnerable',
        is_urgent: 'is_urgent'
      }

      CSV.generate(headers: true) do |csv|
        csv << attributes.values
        all.each do |record|
          csv << attributes.keys.map { |attr| attr == :status ? record.send(:status_label) : record.send(attr) }
        end
      end
    end
  end
  end
