# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :set_contact, only: %i[edit update show show_needs add_needs]

  def index
    @contacts = Contact.all.page(params[:page])
  end

  def show_needs
    @users = User.all
    @need = Need.new
  end

  def show; end

  def edit; end

  def add_needs
    @needs_form = Needs.new
  end

  def update
    if @contact.update(contact_params)
      redirect_to contact_path(@contact), notice: 'Contact was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :middle_names, :surname, :address, :postcode, :email, :telephone,
                                    :mobile, :additional_info, :is_vulnerable, :count_people_in_house, :any_children_below_15,
                                    :delivery_details, :any_dietary_requirements, :dietary_details,
                                    :cooking_facilities, :eligible_for_free_prescriptions)
  end
end
