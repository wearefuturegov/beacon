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

  def show
    @assigned_to_options = construct_assigned_to_options
    @need.notes.order(created_at: :desc)
  end

  def edit
    @roles = Role.all
    @users = User.all
  end

  def update
    if @need.update(need_params)
      redirect_to need_path(@need), notice: 'Need was successfully updated.'
    else
      @users = User.all
      @roles = Role.all
      render :show
    end
  rescue ActiveRecord::StaleObjectError
    flash[:alert] = STALE_ERROR_MESSAGE
    @users = User.all
    @roles = Role.all
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
    params.require(:need).permit(:name, :status, :assigned_to, :category, :is_urgent, :lock_version)
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
