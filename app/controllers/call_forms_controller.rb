# frozen_string_literal: true

class CallFormsController < ApplicationController
  include ParamsConcern

  before_action :set_contact, only: %i[new create]

  def new
    @call_form = ContactCallForm.new
    @call_form.contact = @contact
  end

  def create
    if @contact.update(contact_params)
      NeedsCreator.create_needs(@contact, call_form_params['needs_list'], call_form_params['other_need'])
      redirect_to contact_path(@contact), notice: 'Contact was successfully updated.'
    else
      render :new
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

  def call_form_params
    params.require(:contact_call_form).permit!
  end
end