# frozen_string_literal: true

class TriageController < ApplicationController
  include ParamsConcern

  before_action :set_contact, only: %i[edit update]

  def edit
    @edit_contact_id = @contact.id
    if session[:triage] && session[:triage]['contact_id'] == @contact.id
      @contact.assign_attributes(session[:triage]['contact_params'])
      @contact_needs = ContactNeeds.new(session[:triage]['contact_needs_params'])
      merge_contact_needs
    else
      @contact_needs = create_contact_needs
    end
  end

  def update
    if params.require(:save_for_later)
      save_for_later(@contact.id, contact_params, contact_needs_params)
      redirect_to contact_path(@contact.id), notice: 'Triage temporarely saved.'
    else
      @contact.assign_attributes(contact_params)
      @contact_needs = ContactNeeds.new(contact_needs_params)
      @contact_needs.valid?
      @contact.valid?

      if @contact.errors.any? || @contact_needs.errors.any? || !@contact.save
        merge_contact_needs
        return render :edit
      end

      ContactChannel.broadcast_to(@contact, { userEmail: current_user.email, type: 'CHANGED' })
      NeedsCreator.create_needs(@contact, contact_needs_params['needs_list'], contact_needs_params['other_need'])
      session[:triage] = nil
      redirect_to contact_path(@contact.id), notice: 'Contact was successfully updated.'
    end
  rescue ActiveRecord::StaleObjectError
    flash[:alert] = STALE_ERROR_MESSAGE
    merge_contact_needs
    render :edit
  end

  private

  def save_for_later(contact_id, contact_params, contact_needs_params)
    session[:triage] = {
      contact_id: contact_id,
      contact_params: contact_params,
      contact_needs_params: contact_needs_params
    }
  end

  # repopulate the label/colour data
  def merge_contact_needs
    @contact_needs.needs_list.each_with_index do |need, index|
      need[1].merge!(view_context.needs[index])
    end
  end

  def set_contact
    @contact = Contact.find(params[:contact_id])
    authorize(@contact, :update?)
  end

  def contact_params
    params.require(:contact).permit(:first_name, :middle_names, :surname, :address, :postcode, :email, :telephone,
                                    :mobile, :additional_info, :is_vulnerable, :count_people_in_house, :any_children_below_15,
                                    :delivery_details, :any_dietary_requirements, :dietary_details,
                                    :cooking_facilities, :eligible_for_free_prescriptions, :has_covid_symptoms, :lock_version,
                                    :share_data_flag, :channel)
  end

  def contact_needs_params
    params.require(:contact_needs).permit!
  end

  def create_contact_needs
    contact_model = ContactNeeds.new
    contact_model.needs_list = view_context.needs.each_with_index.map do |need, index|
      need[:active] = 'false'
      need[:start_on] = (Date.today + 6.days).strftime('%d/%m/%Y') if need[:label] == 'Phone triage'
      [index.to_s, need]
    end.to_h
    contact_model
  end
end
