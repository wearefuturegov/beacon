class AssessmentsController < ApplicationController
  before_action :set_contact, only: %i[new create]

  def new
    @users = User.all
    @roles = Role.all
    @type = %w(log schedule).include?(type_param) ? type_param : 'log'

    @need = Need.new
    @need.notes << Note.new

    @need.status = 'complete' if @type == 'log'
    @need.user = current_user if @type == 'log'
  end

  def create

  end

  private
  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def type_param
    params.require(:type)
  end
end