class ContactNeedsValidator < ActiveModel::Validator
  def validate(form)
    form.needs_list.values.each_with_index do |need, _index|
      next unless need[:active] == 'true'

      if need[:name] == 'Phone triage'
        form.errors.add('Phone triage call date', 'is not a valid date') unless valid_date? need[:start_on]
      end
    end
  end

  def valid_date?(date_string)
    DateTime.parse(date_string)
    true
  rescue ArgumentError
    false
  end
end
