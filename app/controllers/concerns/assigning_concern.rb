# frozen_string_literal: true

module AssigningConcern
  extend ActiveSupport::Concern

  included do
    helper_method :construct_assigned_to_options
  end

  def construct_assigned_to_options(with_deleted = false)
    roles = Role.all.order(:name)
    users = with_deleted ? User.all.with_deleted.order(:first_name, :last_name) : User.all.order(:first_name, :last_name)

    {
      'Teams' => roles.map { |role| [role.name, "role-#{role.id}"] },
      'Users' => users.map { |user| [user.name_or_email, "user-#{user.id}"] }
    }
  end

  def assigned_to_me(assigned_to)
    assigned_to = "user-#{current_user.id}" if assigned_to == 'assigned-to-me'
    assigned_to
  end
end
