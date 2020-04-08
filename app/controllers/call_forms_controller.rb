# frozen_string_literal: true

class CallFormsController < ApplicationController
  include ParamsConcern

  before_action :set_contact, only: %i[new create]

  def new
    @call_form = ContactCallForm.new()
    @call_form.contact = @contact
  end

  def create
    Rails.logger.debug params.inspect
  end

  private
    def set_contact
      @contact = Contact.find(params[:contact_id])
    end
end