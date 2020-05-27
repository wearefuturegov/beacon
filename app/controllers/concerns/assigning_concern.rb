# frozen_string_literal: true

module AssigningConcern
  extend ActiveSupport::Concern

  included do
    helper_method :construct_assigned_to_options, :construct_teams_options
  end

  def construct_assigned_to_options(with_deleted = false)

    Rails.cache.fetch(:roles) do
      Role.all.order(:name)
    end
    Rails.cache.fetch(:users_with_deleted) do
      User.all.with_deleted.order(:first_name, :last_name)
    end
    
    roles = Rails.cache.fetch(:roles)
    users = Rails.cache.fetch(:users_with_deleted)
    users = with_deleted ? users : users.reject{|x| x.deleted?}

    {
      'Teams' => roles.map { |role| [role.name, "role-#{role.id}"] },
      'Users' => users.map { |user| [user.name_or_email, "user-#{user.id}"] }
    }
  end

  def construct_teams_options
    Rails.cache.fetch(:roles) do
      Role.all.order(:name)
    end
    roles = Rails.cache.fetch(:roles)
    {
      'Teams' => roles.map { |role| [role.name, role.id.to_s] }
    }
  end
end
