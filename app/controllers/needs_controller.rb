# frozen_string_literal: true

class NeedsController < ApplicationController
  include ParamsConcern
  before_action :set_need, only: %i[show edit update]
  before_action :set_contact, only: %i[new create]

  helper_method :get_param

  def index
    @params = params.permit(:assigned_to, :status, :category, :page, :order_dir, :order, :commit, :is_urgent)
    @users = User.all
    @roles = Role.all
    @needs = policy_scope(Need)
             .started
             .filter_and_sort(@params.slice(:category, :assigned_to, :status, :is_urgent), @params.slice(:order, :order_dir))
    @needs = @needs.page(params[:page]) unless request.format == 'csv'
    @assigned_to_options = construct_assigned_to_options
    respond_to do |format|
      format.html
      format.csv { send_data @needs.to_csv, filename: "needs-#{Date.today}.csv" }
    end
  end

  def destroy
    if params[:note_only] == 'true'
      delete_note params
    else
      delete_need params
    end
  rescue ActiveRecord::StaleObjectError
    flash[:alert] = STALE_ERROR_MESSAGE
    @assigned_to_options = construct_assigned_to_options
    @delete_prompt = get_delete_prompt @need
    render :show
  end

  def show
    @need.notes.order(created_at: :desc)
    populate_page_data
  end

  def edit
    @roles = Role.all
    @users = User.all
    @delete_prompt = get_delete_prompt @need
  end

  def update
    if @need.update(need_params)
      redirect_to need_path(@need), notice: 'Need was successfully updated.'
    else
      populate_page_data
      render :show
    end
  rescue ActiveRecord::StaleObjectError
    flash[:alert] = STALE_ERROR_MESSAGE
    populate_page_data
    render :show
  end

  def assign_multiple
    for_update = JSON.parse(params[:for_update])
    for_update.each do |obj|
      need = Need.find(obj['need_id'])
      authorize(need)
      assigned_to = obj['assigned_to']
      need.update!(assigned_to: assigned_to)
    end
    render json: { status: 'ok' }
  end

  private

  def delete_note(params)
    note = Note.find(params[:id])
    note_name = note.category
    note.destroy

    @need = Need.find(params[:need_id])
    populate_page_data
    
    redirect_to need_path(@need)
  end

  def delete_need(params)
    need = Need.find(params[:id])
    need_name = need.category

    if need.has_notes_by_somebody_else(current_user.id)
      flash[:alert] = "Unable to delete '#{need_name}''. Please delete the attached notes first."
      redirect_to need_path(need) and return
    end
    
    if need.destroy
      redirect_to contact_path(need.contact_id), notice: "'#{need_name}' was successfully deleted."
    else
      populate_page_data
      render :show
    end
  end

  def populate_page_data
    @assigned_to_options = construct_assigned_to_options
    @delete_prompt = get_delete_prompt @need
  end

  def get_delete_prompt(need)
   "Only Delete this #{need.category} if you created it in error. If it is canceled, blocked or completed, please click Cancel and update the status instead.  Click OK to delete?"
  end

  def set_need
    @need = Need.find(params[:id])
    @contact = @need.contact

    authorize(@need)
    authorize(@contact, :show?)
  end

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def need_params
    params.require(:need).permit(:id, :name, :status, :assigned_to, :category, :is_urgent, :lock_version)
  end

  def construct_assigned_to_options
    roles = Role.all.order(:name)
    users = User.all.order(:first_name, :last_name)

    {
      'Teams' => roles.map { |role| [role.name, "role-#{role.id}"] },
      'Users' => users.map { |user| [user.name_or_email, "user-#{user.id}"] }
    }
  end
end
