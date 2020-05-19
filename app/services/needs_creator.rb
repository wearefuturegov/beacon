# frozen_string_literal: true

# Creates needs for a user from a submitted questionnaire form
class NeedsCreator
  def self.create_needs(contact, needs_form, other_need)
    needs_form.each do |_, value|
      if inactive?(value)
        existing = Need.where(id: value['id'])
        existing.first.really_destroy! if existing.exists?
      else
        need_hash = create_need(contact, value)
        Need.find_or_initialize_by(id: value[:id]).update(need_hash)
      end
    end

    if other_need
      contact.needs
             .build(category: 'other', name: other_need, status: Need.statuses[:to_do])
             .save
    end
  end

  def self.active?(value)
    value['active'] == 'true'
  end

  def self.inactive?(value)
    !active?(value)
  end

  def self.create_need(contact, need_values)
    need_hash = {}
    if need_values['id']
      need_hash[:id] = need_values['id']
    end
    if need_values['assessment_id']
      need_hash[:assessment_id] = need_values['assessment_id']
    end
    need_hash[:contact_id] = contact.id
    need_hash[:category] = need_values['name'].humanize.downcase
    need_hash[:name] = if need_values['description'].blank?
                         "#{contact.name} needs #{need_hash[:category]}"
                       else
                         need_values['description']
                       end
    need_hash[:is_urgent] = need_values['is_urgent']
    need_hash[:food_priority] = need_values['food_priority'] if need_values['food_priority'].present?
    need_hash[:food_service_type] = need_values['food_service_type'] if need_values['food_service_type'].present?
    need_hash[:status] = Need.statuses[:to_do]

    if need_values['start_on']
      begin
        need_hash[:start_on] = DateTime.parse(need_values['start_on']).beginning_of_day
      rescue StandardError
        need_hash[:start_on] = DateTime.now.beginning_of_day + 6.days
      end
    end
    need_hash
  end
end
