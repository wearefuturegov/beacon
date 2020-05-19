class AssessmentFailureForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :id
  attr_accessor :failure_reason
  attr_accessor :left_message
  attr_accessor :note_description
  :incorrect_or_missing.to_s
  validates_presence_of :failure_reason
  validates_presence_of :note_description
  validates_presence_of :left_message, if: Proc.new { |form| form.failure_reason == 'call_not_answered' }

  def save(current_user)
    need = Need.find(self.id)
    if self.failure_reason == 'incorrect_or_missing'
      note_description_hash = (self.note_description.downcase.include? '#invalid') ? self.note_description : self.note_description + ' #Invalid'
      need.notes.create!(user: current_user, category: 'general', body: note_description_hash)
      need.update(status: 'blocked')
    else
      need.notes.create!(user: current_user, category: 'phone_failure', body: self.note_description)
    end
  end
end