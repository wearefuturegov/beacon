# frozen_string_literal: true

# Creates needs for a user from a submitted questionnaire form
class NeedsCreator
  def self.create_needs(contact, needs_form, other_need)
    needs_form.each do |_, value|
      next unless value['active'] == 'true'

      need_hash = create_need(contact, value)
      contact.needs.build(need_hash).save
    end

    if other_need
      contact.needs.build(category: 'other', name: other_need).save
    end
  end

  def self.create_need(contact, need_values)
    need_hash = {}
    need_hash[:category] = need_values['name'].humanize.downcase
    need_hash[:name] = if need_values['description'].blank?
                         "#{contact.name} needs #{need_hash[:category]}"
                       else
                         need_values['description']
                       end
    need_hash[:is_urgent] = need_values['is_urgent']

    need_hash[:food_priority] = need_values['food_priority'] if need_values['food_priority'].present?
    need_hash[:food_service_type] = need_values['food_service_type'] if need_values['food_service_type'].present?

    need_hash
  end
end
