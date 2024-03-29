# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :set_contact, :set_teams_options, only: %i[edit update show needs add_needs]
  before_action :roles, only: %i[index search]
  before_action :load_imported_item, only: :index, if: proc { params[:imported_item_id] }
  helper_method :name_for_lead_service

  def index
    @params = params.permit(:page, :imported_item_id)
    model = params[:view] == 'Failed' ? RejectedContact : Contact
    @contacts = policy_scope(model)
    @contacts = @contacts.where(imported_item_id: @params[:imported_item_id]) if @imported_item
    @contacts = @contacts.page(@params[:page])
    AuditLog.create(request_data: audit_request_data, user_id: current_user.id, message: "User viewed contact list page for contact ID: #{@contacts.map(&:id).join(',')}")
  end

  def search
    @params = params.permit(:search, :page, :imported_item_id)
    @contacts = policy_scope(Contact)
    @contacts = Contact.search(@params[:search]).where(id: @contacts.select(:id)) if params[:search]
    @contacts = @contacts.page(@params[:page])
    AuditLog.create(request_data: audit_request_data, user_id: current_user.id, message: "User searched for: '#{params[:search]}' and the following contacts were displayed: #{@contacts.map(&:id).join(',')} on page #{params[:page]}")
    render :index
  end

  def new
    @contact = Contact.new
  end

  def create
    authorize Contact
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to contact_path(@contact), notice: 'Contact was successfully created.'
    else
      render :new
    end
  end

  def call_list; end

  def needs
    @users = User.all.with_deleted
    @need = Need.new
    render :show_needs
  end

  def show
    AuditLog.create(request_data: audit_request_data, user_id: current_user.id, message: "User viewed contacts details page for contact ID: #{@contact.id}")
    @browser = Browser.new(request.env['HTTP_USER_AGENT'])

    @open_needs = policy_scope(@contact.needs, policy_scope_class: ContactNeedsPolicy::Scope)
                  .uncompleted.not_assessments.not_pending
                  .order(created_at: :desc)

    @completed_needs = policy_scope(@contact.needs, policy_scope_class: ContactNeedsPolicy::Scope)
                       .completed.not_assessments.not_pending

    # We want past calls ordered by created date (most recent first), and
    # scheduled calls ordered by start_on, with calls scheduled in the future last
    assessments = policy_scope(@contact.needs, policy_scope_class: ContactNeedsPolicy::Scope)
                  .assessments
    past_assessments = assessments.where('start_on <= ?', DateTime.now).order(created_at: :desc)
    future_assessments = assessments.where('start_on > ?', DateTime.now).order(start_on: :asc)
    @assessments = past_assessments + future_assessments

    @past_call_count = policy_scope(@contact.needs, policy_scope_class: ContactNeedsPolicy::Scope).completed.assessments.not_pending.count
    @scheduled_call_count = policy_scope(@contact.needs, policy_scope_class: ContactNeedsPolicy::Scope).uncompleted.assessments.not_pending.count
  end

  def edit
    AuditLog.create(request_data: audit_request_data, user_id: current_user.id, message: "User viewed contacts edit page for contact ID: #{@contact.id}")
  end

  def update
    if @contact.update(contact_params)
      ContactChannel.broadcast_to(@contact, { userEmail: current_user.email, type: 'CHANGED' })
      respond_to do |format|
        format.html { redirect_to contact_path(@contact), notice: 'Contact was successfully updated.' }
        format.js
      end
    else
      invalid_update
    end
  rescue ActiveRecord::StaleObjectError
    @contact.errors.add(:lock_version, :blank, message: STALE_ERROR_MESSAGE)
    invalid_update
  end

  def name_for_lead_service(role_id)
    return unless role_id.present?

    @roles.select { |i| i.id == role_id }.first.name
  end

  def roles
    @roles = Role.all
  end

  private

  def invalid_update
    respond_to do |format|
      format.html { render :edit }
      format.js
      format.json { render json: @contact.errors, status: :unprocessable_entity }
    end
  end

  def construct_teams_options
    roles = Role.all.order(:name)
    {
      'Teams' => roles.map { |role| [role.name, role.id.to_s] }
    }
  end

  def set_contact
    @contact = Contact.find(params[:id])
    authorize(@contact)
  end

  def set_teams_options
    @teams_options = construct_teams_options
  end

  def contact_params # rubocop:disable Metrics/MethodLength
    params.require(:contact).permit(
      :additional_info,
      :address,
      :any_children_under_age,
      :any_dietary_requirements,
      :channel,
      :cooking_facilities,
      :count_people_in_house,
      :date_of_birth,
      :deceased_flag,
      :delivery_details,
      :dietary_details,
      :eligible_for_free_prescriptions,
      :email,
      :first_name,
      :has_covid_symptoms,
      :isolation_start_date,
      :is_vulnerable,
      :lock_version,
      :lead_service_id,
      :lead_service_note,
      :middle_names,
      :mobile,
      :nhs_number,
      :no_calls_flag,
      :postcode,
      :share_data_flag,
      :surname,
      :telephone,
      :test_and_trace_account_id,
      :test_trace_creation_date,
      :business_name
    )
  end

  def extract_role_id(role_id)
    role_id.split('-').second
  end

  def load_imported_item
    @imported_item = ImportedItem.where(id: params[:imported_item_id]).first
  end
end
