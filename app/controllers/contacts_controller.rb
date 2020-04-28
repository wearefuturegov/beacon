# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :set_contact, only: %i[edit update show needs add_needs]

  def index
    @params = params.permit(:search, :page)
    @contacts = policy_scope(Contact)
    @contacts = Contact.search(@params[:search]).where(id: @contacts.select(:id)) if @params[:search].present?
    @contacts = @contacts.page(@params[:page])
  end

  def call_list; end

  def needs
    @users = User.all
    @need = Need.new
    render :show_needs
  end

  def show
    @open_needs = policy_scope(@contact.needs, policy_scope_class: ContactNeedsPolicy::Scope).where(completed_on: nil).sort { |a, b| Need.sort_created_and_start_date(a, b) }
    @completed_needs = policy_scope(@contact.needs, policy_scope_class: ContactNeedsPolicy::Scope).where.not(completed_on: nil)
  end

  def edit
    @edit_contact_id = @contact.id
  end

  def update
    if @contact.update(contact_params)
      ContactChannel.broadcast_to(@contact, { userEmail: current_user.email, type: 'CHANGED' })
      redirect_to contact_path(@contact), notice: 'Contact was successfully updated.'
    else
      render :edit
    end
  rescue ActiveRecord::StaleObjectError
    flash[:alert] = STALE_ERROR_MESSAGE
    render :edit
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
    authorize(@contact)
  end

  def contact_params
    params.require(:contact).permit(:first_name, :middle_names, :surname, :address, :postcode, :email, :telephone,
                                    :mobile, :additional_info, :is_vulnerable, :count_people_in_house, :any_children_below_15,
                                    :delivery_details, :any_dietary_requirements, :dietary_details,
                                    :cooking_facilities, :eligible_for_free_prescriptions, :has_covid_symptoms, :lock_version,
                                    :channel, :no_calls_flag, :deceased_flag, :share_data_flag)
  end
end
