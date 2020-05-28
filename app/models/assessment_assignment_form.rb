class AssessmentAssignmentForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :id
  attr_accessor :needs

  def self.from_id(id)
    form = AssessmentAssignmentForm.new
    form.id = id
    form.needs = Need.where(assessment_id: id)
    form
  end

  def save
    return true if needs.nil?

    needs.each do |need_params|
      need = Need.find(need_params[0])
      need.assigned_to = need_params[1]['assigned_to']
      need.send_email = need_params[1]['send_email']
      need.status = need_params[1]['status'] if need_params[1]['status'].present?
      need.save
    end
  end
end
