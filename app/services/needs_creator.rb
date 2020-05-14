# frozen_string_literal: true

# Creates needs for a user from a submitted questionnaire form
class NeedsCreator
  def self.create_needs(contact, needs_form, other_need, assessment_id)
    needs = contact.needs
    needs_form.each do |_, value|
      existing = needs.find {|n|n.id == value['id']}
      if existing && value['active'] != true
        existing.destroy
      end

      next unless value['active'] == 'true'

      need_hash = create_need(contact, value, assessment_id)
      Need.find_or_initialize_by(id: value[:id]).update(need_hash)
    end

    if other_need
      contact.needs
             .build(category: 'other', name: other_need, status: Need.statuses[:to_do])
             .save
    end
  end

  def self.create_need(contact, need_values, assessment_id)
    need_hash = {}
    if need_values['id']
      need_hash[:id] = need_values['id']
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

    if assessment_id
      need_hash[:assessment_id] = assessment_id
      need_hash[:status] = Need.statuses[:pending]
      else
      need_hash[:status] = Need.statuses[:to_do]
    end

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
