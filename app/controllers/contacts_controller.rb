class ContactsController < ApplicationController

  before_action :set_contact, only: [:edit, :update]

  def index
    @contacts = Contact.all
  end

  # GET /contacts/1/edit
  def edit
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
  end

  private
    def set_contact
      @contact = Contact.find(params[:id])
    end
end
