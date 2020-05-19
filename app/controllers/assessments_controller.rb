class AssessmentsController < ApplicationController
  before_action :set_globals, only: %i[new create edit]

  # Do Assessment
  def edit
    redirect_to contact_path(@contact) unless @need.category.downcase.in? Need::ASSESSMENT_CATEGORIES
    @contact_needs = contact_needs(@need.id)
  end

  # Save the assessment with an assessment_id
  def update
    @contact.assign_attributes(contact_params)
    @contact_needs = ContactNeeds.new(contact_needs_params)
    @contact_needs.valid?
    @contact.valid?

    render(:edit) && return if @contact.errors.any? || @contact_needs.errors.any? || !@contact.save

    ContactChannel.broadcast_to(@contact, { userEmail: current_user.email, type: 'CHANGED' })
    NeedsCreator.create_needs(@contact, contact_needs_params['needs_list'], contact_needs_params['other_need'])
    session[:triage] = nil
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

  def contact_needs(need_id)
    needs = Need.all.where(assessment_id: need_id)
    needs.empty? ? create_contact_needs : needs
  end

  def create_contact_needs
    contact_model = ContactNeeds.new
    contact_model.needs_list = Need.categories_for_assessment.each_with_index.map do |(label, _slug), index|
      need = {
        name: label,
        active: false
      }
      if label == 'Phone triage'
        need[:active] =
          need[:start_on] = (Date.today + 6.days).strftime('%d/%m/%y')
      end
      [index.to_s, need]
    end.to_h
    contact_model
  end

  def set_globals
    @need = Need.find(params[:id])
    @assessment_id = @need.id
    contact_id = params[:contact_id].present? ? params[:contact_id] : @need.contact_id
    @contact = Contact.find(contact_id)
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

  def type_param
    params.require(:type)
  end

  def assessment_params
    params.require(:need).permit(:assigned_to, :name, :is_urgent, :status, :category, :status, :start_on, :assessment_id)
  end

  def notes_params
    params.require(:note).permit(:body)
  end

  def construct_assigned_to_options
    roles = Role.all.order(:name)
    users = User.all.order(:first_name, :last_name)

    {
      'Teams' => roles.map { |role| [role.name, "role-#{role.id}"] },
      'Users' => users.map { |user| [user.name_or_email, "user-#{user.id}"] }
    }
  end
end
