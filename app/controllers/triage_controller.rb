# frozen_string_literal: true

class TriageController < ApplicationController
  include ParamsConcern

  before_action :set_contact, only: %i[edit update]

  def edit
    @edit_contact_id = @contact.id
    @contact_needs = create_contact_needs
  end

  def update
    @contact.assign_attributes(contact_params)
    @contact_needs = ContactNeeds.new(contact_needs_params)
    @contact_needs.valid?
    @contact.valid?

    render(:edit) && return if @contact.errors.any? || @contact_needs.errors.any? || !@contact.save

    ContactChannel.broadcast_to(@contact, { userEmail: current_user.email, type: 'CHANGED' })
    NeedsCreator.create_needs(@contact, contact_needs_params['needs_list'], contact_needs_params['other_need'])
    session[:triage] = nil

    if params[:assessment_id]
      redirect_to edit_contact_assessment_path(@contact.id, params[:assessment_id], :stage => 'complete')
      else
      redirect_to contact_path(@contact.id), notice: 'Contact was successfully updated.'
    end
  rescue ActiveRecord::StaleObjectError
    flash[:alert] = STALE_ERROR_MESSAGE
    render :edit
  end

  private

  def set_contact
    @contact = Contact.find(params[:contact_id])
    authorize(@contact, :update?)
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

  def create_contact_needs
    contact_model = ContactNeeds.new
    contact_model.needs_list = Need.categories_for_triage.each_with_index.map do |(label, _slug), index|
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

  def submitted_value(need_type)
    contact_needs_params[:needs_list].values.find { |k| k[:name] == need_type }
  end
end
