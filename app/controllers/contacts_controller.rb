class ContactsController < ApplicationController
  before_action :set_contact, only: [:edit, :update, :show, :show_needs, :add_needs]

  def index
    @params = params.permit(:search)
    @contacts = Contact.all

    if @params[:search].present?
      @contacts = @contacts.search(@params[:search])
    end

    @contacts = @contacts.page(@params[:page])
  end

  def show_needs
    @users = User.all
    @need = Need.new
  end

  def show
  end

  def edit
  end

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
    params.require(:contact).permit(:first_name, :middle_names, :surname, :address, :postcode, :email, :telephone, :mobile, :additional_info, :is_vulnerable)
  end
end
