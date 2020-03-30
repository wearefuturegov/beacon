class ContactsController < ApplicationController
  before_action :set_contact, only: [:edit, :update, :show]

  def index
    @contacts = Contact.all.page(params[:page])
  end

  def show
    @users = User.all
    @task = Task.new
  end

  def edit
  end

  def update
    if @contact.update(contact_params)
      redirect_to contacts_path, notice: 'Contact was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :middle_names, :surname, :address, :postcode, :email, :telephone, :mobile)
  end
end
