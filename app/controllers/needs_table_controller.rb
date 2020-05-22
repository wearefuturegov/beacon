# frozen_string_literal: true

class NeedsTableController < ApplicationController
  include ParamsConcern

  helper_method :filters_path, :categories, :can_bulk_action?

  def construct_assigned_to_options(with_deleted = false)
    roles = Role.all.order(:name)
    users = with_deleted ? User.all.with_deleted.order(:first_name, :last_name) : User.all.order(:first_name, :last_name)

    {
      'Teams' => roles.map { |role| [role.name, "role-#{role.id}"] },
      'Users' => users.map { |user| [user.name_or_email, "user-#{user.id}"] }
    }
  end

  def handle_response_formats
    respond_to do |format|
      format.html
      format.csv do
        authorize(Need, :export?)
        send_data @needs.to_csv, filename: "needs-#{Date.today}.csv"
      end
    end
  end

  def needs(start_on = nil)
    if @params[:created_by_me] == 'true'
      @assigned_to_options = {}
      Need.created_by(current_user.id).filter_by_assigned_to('Unassigned')
    else
      @assigned_to_options = construct_assigned_to_options
      policy_scope(Need).started(start_on)
    end
  end

  def filters_path
    root_path
  end

  def categories
    Need.categories
  end

  def can_bulk_action?
    true
  end

  protected

  def need_params
    permit_need_params = params
                         .require(:need)
                         .permit(:id, :name, :status, :assigned_to, :category, :is_urgent, :lock_version, :food_priority, :food_service_type, :start_on)
    permit_need_params[:assigned_to] = assigned_to_me(permit_need_params[:assigned_to])
    permit_need_params
  end

  def assigned_to_me(assigned_to)
    assigned_to = "user-#{current_user.id}" if assigned_to == 'assigned-to-me'
    assigned_to
  end
end
