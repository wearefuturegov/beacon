class AssessmentFailureForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :failure_reason
  attr_accessor :left_message
  attr_accessor :note_description

  validates_presence_of :failure_reason
  validates_presence_of :note_description
  validates_presence_of :left_message, if: Proc.new { |form| form.failure_reason == 'call_not_answered' }

  def save
    puts 'hi'
  end
end