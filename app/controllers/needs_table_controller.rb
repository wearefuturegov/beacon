# frozen_string_literal: true

class NeedsTableController < ApplicationController
  include ParamsConcern

  def construct_assigned_to_options(with_deleted = false)
    roles = Role.all.order(:name)
    users = with_deleted ? User.all.with_deleted.order(:first_name, :last_name) : User.all.order(:first_name, :last_name)

    {
      'Teams' => roles.map { |role| [role.name, "role-#{role.id}"] },
      'Users' => users.map { |user| [user.name_or_email, "user-#{user.id}"] }
    }
  end
  
  protected

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
