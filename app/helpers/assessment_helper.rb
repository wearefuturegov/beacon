# frozen_string_literal: true

module AssessmentHelper
  def assessment_failure_reasons
    {
      incorrect_or_missing: 'Contact details were incorrect or missing',
      call_not_answered: 'The call was not answered',
      other: 'Other reason'
    }
  end

  def assessment_completion_methods
    {
        phone_success: 'Successful Call',
        general: 'Other'
    }
  end
end
