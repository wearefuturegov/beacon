class AssessmentsController < ApplicationController
  before_action :set_contact, only: %i[new create]
  before_action :set_globals, only: :edit

  # Do Assessment
  def edit
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
    redirect_to contact_path(@contact.id), notice: 'Contact was successfully updated.'
  rescue ActiveRecord::StaleObjectError
    flash[:alert] = STALE_ERROR_MESSAGE
    render :edit
  end

  # Assign
  def assign; end

  # Complete
  def complete; end

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
    contact_model.needs_list = Need.categories_for_triage.each_with_index.map do |(label, _slug), index|
      existing_need = existing_needs.find {|n|n.category == label}
      need = {
          id: existing_need&.id,
          name: label,
          description: existing_need&.name,
          food_priority: existing_need&.food_priority,
          food_service_type: existing_need&.food_service_type,
          active: existing_need != nil ? 'true' : 'false',
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
    @contact = Contact.find(params[:contact_id])
  end

  def find_contact_id
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

  def construct_assigned_to_options
    roles = Role.all.order(:name)
    users = User.all.order(:first_name, :last_name)

    {
      'Teams' => roles.map { |role| [role.name, "role-#{role.id}"] },
      'Users' => users.map { |user| [user.name_or_email, "user-#{user.id}"] }
    }
  end

  def type_param
    params.require(:type)
  end

  def assessment_params
    params.require(:need).permit(:assigned_to, :name, :is_urgent, :status, :category, :status, :start_on, :assessment_id)
  end

  def notes_params
    params.require(:note).permit(:body)
  end

  def contact_params
    params.require(:contact).permit(:first_name, :middle_names, :surname, :date_of_birth, :nhs_number, :address, :postcode, :email, :telephone,
                                    :mobile, :additional_info, :is_vulnerable, :count_people_in_house, :any_children_under_age,
                                    :delivery_details, :any_dietary_requirements, :dietary_details,
                                    :cooking_facilities, :eligible_for_free_prescriptions, :has_covid_symptoms, :lock_version,
                                    :no_calls_flag, :deceased_flag, :share_data_flag, :channel, :assessment_id)
  end

  def contact_needs_params
    params.require(:contact_needs).permit!
  end

end
