# frozen_string_literal: true

class TriageController < ApplicationController
  include ParamsConcern

  before_action :set_contact, only: %i[edit update]

  def edit
    @contact_needs = ContactNeeds.new
  end

  def update
    if @contact.update(contact_params)
      NeedsCreator.create_needs(@contact, contact_needs_params['needs_list'], contact_needs_params['other_need'])
      redirect_to contact_path(@contact.id), notice: 'Contact was successfully updated.'
    else
      @contact_need = ContactNeeds.new
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
                                    :cooking_facilities, :eligible_for_free_prescriptions)
  end

  def contact_needs_params
    params.require(:contact_needs).permit!
  end
end
