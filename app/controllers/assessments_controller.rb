class AssessmentsController < ApplicationController
  before_action :set_contact, only: %i[new create]
  before_action :set_assessment, only: %i[fail update_failure assign update_assignment]
  include AssigningConcern

  def new
    @assigned_to_options = construct_assigned_to_options
    @type = %w[log schedule].include?(type_param) ? type_param : 'log'

    @need = Need.new
    @note = Note.new

    @need.status = 'complete' if @type == 'log'
    @need.user = current_user if @type == 'log'
  end

  def create
    authorize Need
    @type = %w[log schedule].include?(type_param) ? type_param : 'log'
    if @type == 'log'
      log_assessment
    else
      schedule_assessment
    end
  end

  def fail
    @failure_form = AssessmentFailureForm.new
  end

  def update_failure
    @failure_form = AssessmentFailureForm.new(assessment_failure_params.merge(id: params[:id]))
    if @failure_form.valid? && @failure_form.save(current_user)
      redirect_to need_path(@assessment), notice: 'Record successfully updated.'
      return
    end
    render :fail
  end

  def assign
    @assigned_to_options = construct_assigned_to_options(true)
    @assignment_form = AssessmentAssignmentForm.from_id(params[:id])
  end

  def update_assignment
    @assignment_form = AssessmentAssignmentForm.new(assessment_assignment_params.merge(id: params[:id]))
    @assignment_form.save

    render plain: 'Redirected to assessment completion'
    # to do: implement redirecting to assessment completion
    # redirect_to complete_assessment_path(params[:id])
  end

  private

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def set_assessment
    @assessment = Need.find(params[:id])
    @contact = Contact.find(@assessment.contact_id)
  end

  def log_assessment
    @need = Need.new(assessment_params.merge(contact_id: @contact.id, name: 'Logged assessment', start_on: Date.today))
    @note = Note.new(notes_params.merge(need: @need, category: 'phone_success', user_id: current_user.id))
    if @need.valid? && @note.valid? && @need.save && @note.save
      redirect_to contact_path(@contact)
      return
    end

    @assigned_to_options = construct_assigned_to_options
    render :new
  end

  def schedule_assessment
    @need = Need.new(assessment_params.merge(contact_id: @contact.id))
    @note = Note.new
    unless @need.valid?
      @assigned_to_options = construct_assigned_to_options
      render :new
      return
    end

    @need.save
    redirect_to contact_path(@contact)
  end

  def type_param
    params.require(:type)
  end

  def assessment_params
    params.require(:need).permit(:assigned_to, :name, :is_urgent, :status, :category, :status, :start_on)
  end

  def assessment_failure_params
    params.require(:assessment_failure_form).permit(:failure_reason, :left_message, :note_description)
  end

  def assessment_assignment_params
    params.require(:assessment_assignment_form).permit(needs: [:id, :assigned_to])
  end

  def notes_params
    params.require(:note).permit(:body)
  end
end
