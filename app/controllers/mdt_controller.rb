# frozen_string_literal: true

class MdtController < ApplicationController
  include ParamsConcern
  before_action :set_need, only: %i[show edit update]
  before_action :set_contact, only: %i[new create]

  helper_method :get_param

  def index
    @params = params.permit(:assigned_to, :status, :page, :order_dir, :order, :commit, :is_urgent, :created_by_me)
    @needs = if @params[:created_by_me] == 'true'
               @assigned_to_options = {}
               Need.created_by(current_user.id).filter_by_assigned_to('Unassigned')
             else
               @assigned_to_options = construct_assigned_to_options
               policy_scope(Need).started
             end

    @params[:category] = 'mdt review'
    @needs = @needs.uncompleted.filter_and_sort(@params.slice(:category, :assigned_to, :status, :is_urgent), @params.slice(:order, :order_dir))
    @needs = @needs.page(params[:page]) unless request.format == 'csv'
    @assigned_to_options_with_deleted = construct_assigned_to_options(true)
    respond_to do |format|
      format.html
      format.csv do
        authorize(Need, :export?)
        send_data @needs.to_csv, filename: "needs-#{Date.today}.csv"
      end
    end
  end

  def construct_assigned_to_options(with_deleted = false)
    roles = Role.all.order(:name)
    users = with_deleted ? User.all.with_deleted.order(:first_name, :last_name) : User.all.order(:first_name, :last_name)

    {
      'Teams' => roles.map { |role| [role.name, "role-#{role.id}"] },
      'Users' => users.map { |user| [user.name_or_email, "user-#{user.id}"] }
    }
  end

  private

  def need_params
    permit_need_params = params.require(:need).permit(:id, :name, :status, :assigned_to, :category, :is_urgent, :lock_version)
    permit_need_params[:assigned_to] = assigned_to_me(permit_need_params[:assigned_to])
    permit_need_params
  end

  def assigned_to_me(assigned_to)
    assigned_to = "user-#{current_user.id}" if assigned_to == 'assigned-to-me'
    assigned_to
  end


end
