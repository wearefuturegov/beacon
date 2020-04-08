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

  def show
    @generic_notes = @contact.needs.flat_map{|n| n.notes}.select{|y| y[:note_type]=='generic'}
    @failed_calls = sort_notes_by_date(@contact.needs.flat_map{|n| n.notes}.select{|y| y[:note_type]=='phone_fail'})
    @success_calls = sort_notes_by_date(@contact.needs.flat_map{|n| n.notes}.select{|y| y[:note_type]=='phone_success'})
  end

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
  
  def sort_notes_by_date(arr)
    arr.sort_by { |h| h["updated_at"].reverse }
  end

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :middle_names, :surname, :address, :postcode, :email, :telephone, :mobile, :additional_info, :is_vulnerable)
  end
end
