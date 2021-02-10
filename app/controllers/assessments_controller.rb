class AssessmentsController < ApplicationController
  before_action :set_contact, only: %i[new create]
  before_action :set_assessment, only: %i[fail update_failure edit update assign update_assignment complete update_completion start]
  include AssigningConcern
  before_action :set_globals, only: :edit

  # Do Assessment
  def edit
    AuditLog.create(user_id: current_user.id, message: "User requested to start assessment on contact ID: #{@contact.id}")
    redirect_to contact_path(@contact) unless @need.category.downcase.in? Need::ASSESSMENT_CATEGORIES
    @contact_needs = contact_needs(@need.id)
  end

  # Save the assessment with an assessment_id
  def update
    @contact = Contact.find(params[:contact_id])
    @contact.assign_attributes(contact_params)
    @contact_needs = ContactNeeds.new(contact_needs_params)
    @contact_needs.valid?
    @contact.valid?
    render(:edit) && return if @contact.errors.any? || @contact_needs.errors.any? || !@contact.save

    ContactChannel.broadcast_to(@contact, { userEmail: current_user.email, type: 'CHANGED' })
    NeedsCreator.create_needs(@contact, contact_needs_params['needs_list'], contact_needs_params['other_need'])

    if params[:status] == 'fail'
      redirect_to fail_assessment_path(@assessment.id), notice: 'Updated assessment'
    else
      redirect_to assign_assessment_path(@assessment.id), notice: 'Updated assessment'
    end

    AuditLog.create(user_id: current_user.id, message: "User updated assessment ID #{@assessment.id} on contact ID: #{@contact.id}")
  rescue ActiveRecord::StaleObjectError
    flash[:alert] = STALE_ERROR_MESSAGE
    render :edit
  end

  def new
    AuditLog.create(user_id: current_user.id, message: 'User requested page: new assessment')
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
    AuditLog.create(user_id: current_user.id, message: "User created a new assessment on contact ID: #{@contact.id}")
  end

  def start; end

  def fail
    AuditLog.create(user_id: current_user.id, message: "User requested fail assignment page for assessment ID: #{params[:id]}")
    @failure_form = AssessmentFailureForm.new
  end

  def update_failure
    AuditLog.create(user_id: current_user.id, message: "User updated failed assignment for assessment ID: #{params[:id]}")
    @failure_form = AssessmentFailureForm.new(assessment_failure_params.merge(id: params[:id]))
    if @failure_form.valid? && @failure_form.save(current_user)
      redirect_to need_path(@assessment), notice: 'Record successfully updated.'
      return
    end
    render :fail
  end

  def assign
    AuditLog.create(user_id: current_user.id, message: "User requested update assignment page for assessment ID: #{params[:id]}")
    @assigned_to_options = construct_assigned_to_options(true)
    @assignment_form = AssessmentAssignmentForm.from_id(params[:id])
  end

  def update_assignment
    AuditLog.create(user_id: current_user.id, message: "User updated assignments for assessment ID: #{params[:id]}")
    @assignment_form = AssessmentAssignmentForm.new(assessment_assignment_params.merge(id: params[:id]))
    @assignment_form.save

    redirect_to complete_assessment_path(params[:id])
  end

  # Complete
  def complete
    AuditLog.create(user_id: current_user.id, message: "User request page complete assessment on contact ID: #{@contact.id}")
    @completion_form = AssessmentCompletionForm.new(id: params[:id])
    @completion_form.existing_check_in = Need.where(contact_id: @contact.id, category: 'Check in', status: Need.statuses[:to_do]).where.not(id: @assessment.id).first
    @completion_form.existing_mdt_review = Need.where(contact_id: @contact.id, category: 'mdt review', status: Need.statuses[:to_do]).first
    @completion_form.mdt_review_is_urgent = @completion_form.existing_mdt_review&.is_urgent ? '1' : '0'
  end

  def update_completion
    @completion_form = AssessmentCompletionForm.new(assessment_completion_params.merge(id: params[:id]))
    @completion_form.existing_check_in = Need.where(contact_id: @contact.id, category: 'Check in', status: Need.statuses[:to_do]).where.not(id: @assessment.id).first
    @completion_form.existing_mdt_review = Need.where(contact_id: @contact.id, category: 'mdt review', status: Need.statuses[:to_do]).first
    AuditLog.create(user_id: current_user.id, message: "User completed assessment on contact ID: #{@contact.id}")
    if @completion_form.valid? && @completion_form.save(current_user)
      redirect_to contact_path(@contact.id), notice: 'Assessment completed.'
    else
      render :complete
    end
  end

  private

  def contact_needs(assessment_id)
    needs = Need.where(assessment_id: assessment_id).to_a
    create_contact_needs(needs)
  end

  def needs_to_hashes(needs)
    Hash[needs.map { |i| [i.attributes] }]
  end

  def create_contact_needs(existing_needs)
    contact_model = ContactNeeds.new
    contact_model.needs_list = Need.categories_for_assessment.each_with_index.map do |(label, _slug), index|
      existing_need = existing_needs.find { |n| n.category == label }
      need = {
        id: existing_need&.id,
        name: label,
        description: existing_need&.name,
        is_urgent: existing_need&.is_urgent? ? '1' : '0',
        food_priority: existing_need&.food_priority,
        food_service_type: existing_need&.food_service_type,
        active: !existing_need.nil? ? 'true' : 'false'
      }
      [index.to_s, need]
    end.to_h
    contact_model
  end

  def set_globals
    @need = Need.find(params[:id])
    @assessment_id = @need.id
    set_contact
  end

  def set_contact
    contact_id = params[:contact_id].present? ? params[:contact_id] : @need.contact_id
    @contact = Contact.find(contact_id)
  end

  def set_assessment
    @assessment = Need.find(params[:id])
    @contact = Contact.find(@assessment.contact_id)
  end

  def find_contact_id; end

  def log_assessment
    @need = Need.new(assessment_params.merge(contact_id: @contact.id, start_on: Date.today))
    notes_permit_params = notes_params.merge(need: @need, category: 'phone_success', user_id: current_user.id)
    @note = Note.new(notes_permit_params)
    if @need.valid? && @need.save && (notes_permit_params[:body].empty? || @note.valid? && @need.save && @note.save)
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
    params.require(:need).permit(:assigned_to, :name, :is_urgent, :status, :category, :status, :start_on, :assessment_id, :send_email)
  end

  def assessment_failure_params
    params.require(:assessment_failure_form).permit(:failure_reason, :left_message, :note_description)
  end

  def assessment_assignment_params
    permit_params = params.require(:assessment_assignment_form).permit(needs: [:id, :assigned_to, :status, :send_email])
    permit_params[:needs].to_h.each do |key, _value|
      permit_params[:needs][key]['assigned_to'] = assigned_to_me(permit_params[:needs][key]['assigned_to'])
    end
    permit_params
  end

  def assessment_completion_params
    params.require(:assessment_completion_form).permit(:completion_method, :completion_note, :next_check_in_date, :next_check_in_description, :mdt_review_is_urgent, :mdt_review_note)
  end

  def notes_params
    params.require(:note).permit(:body)
  end

  def contact_params
    params.require(:contact).permit(:first_name, :middle_names, :surname, :date_of_birth, :nhs_number, :address, :postcode, :email, :telephone,
                                    :mobile, :additional_info, :is_vulnerable, :count_people_in_house, :any_children_under_age,
                                    :delivery_details, :any_dietary_requirements, :dietary_details,
                                    :cooking_facilities, :eligible_for_free_prescriptions, :has_covid_symptoms, :lock_version,
                                    :no_calls_flag, :deceased_flag, :share_data_flag, :channel)
  end

  def contact_needs_params
    params.require(:contact_needs).permit!
  end
end
