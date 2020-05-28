class AssessmentCompletionForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :id

  attr_accessor :existing_check_in
  attr_accessor :existing_mdt_review

  attr_accessor :completion_method
  attr_accessor :completion_note
  attr_accessor :next_check_in_date
  attr_accessor :mdt_review_is_urgent
  attr_accessor :mdt_review_note

  validates :completion_method, presence: true
  validates :completion_note, presence: true

  validates_presence_of :mdt_review_note, if: proc { |form| form.needs_assigned_to_mdt.any? }

  def save(current_user)
    assessment = Need.find(id)
    contact = Contact.find(assessment.contact_id)
    if next_check_in_date && !existing_check_in
      contact.needs.build(category: 'check in', start_on: next_check_in_date, status: Need.statuses[:to_do], name: 'Check In')
             .save
    end
    if needs_assigned_to_mdt.any?
      if existing_mdt_review
        existing_mdt_review.update(is_urgent: existing_mdt_review.is_urgent || mdt_review_is_urgent == '1')
        existing_mdt_review.notes.build(user_id: current_user, body: mdt_review_note).save
      else
        mdt_role_id = Role.where(tag: 'mdt').first.id
        contact.needs.build(category: 'mdt review', start_on: DateTime.now.beginning_of_day,
                            status: Need.statuses[:to_do], name: mdt_review_note, role_id: mdt_role_id, is_urgent: mdt_review_is_urgent == '1').save
      end
    end

    assessment.notes.build(user_id: current_user.id, category: completion_method, body: "Completed #{assessment.category.humanize}")
    assessment.update(status: 'complete')
    needs_to_update = Need.where(assessment_id: assessment.id)

    needs_to_update.each { |need| NeedsAssigneeNotifier.notify_new_assignee(need) }
    needs_to_update.update_all(assessment_id: nil)
  end

  def needs_assigned_to_mdt
    mdt_role_id = Role.where(tag: 'mdt').first.id
    Need.where(assessment_id: id, role_id: mdt_role_id)
  end
end
