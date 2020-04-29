class AssessmentsController < ApplicationController
  before_action :set_contact, only: %i[new create]

  def new
    @users = User.all
    @roles = Role.all
    @type = %w[log schedule].include?(type_param) ? type_param : 'log'

    @need = Need.new
    @note = Note.new

    @need.status = 'complete' if @type == 'log'
    @need.user = current_user if @type == 'log'
  end

  def create
    @type = %w[log schedule].include?(type_param) ? type_param : 'log'
    if @type == 'log'
      log_assessment
    else
      schedule_assessment
    end
  end

  private

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def log_assessment
    @need = Need.new(assessment_params.merge(contact: @contact, name: 'Logged Assessment'))
    @note = Note.new(notes_params.merge(need: @need))
    if @need.valid? && @note.valid? && @need.save && @note.save
      redirect_to contact_path(@contact)
      return
    end

    @users = User.all
    @roles = Role.all
    render :new
  end

  def schedule_assessment
    @need = Need.new(assessment_params.merge(contact: @contact, name: 'Scheduled Assessment'))
    @note = Note.new
    unless @need.valid? && @need.valid_start_on?
      @users = User.all
      @roles = Role.all
      render :new
      return
    end

    @need.save
    redirect_to contact_path(@contact)
  end

  def type_param
    params.require(:type)
  end

  def assessment_params
    params.require(:need).permit(:user_id, :role_id, :is_urgent, :status, :category, :status, :start_on)
  end

  def notes_params
    params.require(:note).permit(:body)
  end
end
