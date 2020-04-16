class ContactNeedsValidator < ActiveModel::Validator
  def validate(form)
    form.needs_list.values.each_with_index do |need, index|
      next unless need[:active]
      if need[:name] == 'phone_triage'
        form.errors.add("Phone triage call date", "is not a valid date") unless is_valid_date? need[:start_on]
      end
    end
  end

  def is_valid_date?(date_string)
    DateTime.parse(date_string)
    true
  rescue ArgumentError
    false
  end
end