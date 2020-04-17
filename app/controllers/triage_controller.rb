# frozen_string_literal: true

class TriageController < ApplicationController
  include ParamsConcern

  before_action :set_contact, only: %i[edit update]

  def edit
    @contact_needs = create_contact_needs
  end

  def update
    @contact.assign_attributes(contact_params)
    @contact_needs = ContactNeeds.new(contact_needs_params)
    unless @contact_needs.valid?
      view_context.needs.each_with_index do |need, index|
        @contact_needs.needs_list[index.to_s].merge!(need)
      end
      return render :edit
    end

    if @contact.update(contact_params)
      NeedsCreator.create_needs(@contact, contact_needs_params['needs_list'], contact_needs_params['other_need'])
      redirect_to contact_path(@contact.id), notice: 'Contact was successfully updated.'
    else
      @contact_needs = ContactNeeds.new
      render :edit
    end
  end

  private

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :middle_names, :surname, :address, :postcode, :email, :telephone,
                                    :mobile, :additional_info, :is_vulnerable, :count_people_in_house, :any_children_below_15,
                                    :delivery_details, :any_dietary_requirements, :dietary_details,
                                    :cooking_facilities, :eligible_for_free_prescriptions, :has_covid_symptoms)
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
