# frozen_string_literal: true

module AssigningConcern
  extend ActiveSupport::Concern

  included do
    helper_method :construct_assigned_to_options, :construct_teams_options
  end

  def construct_assigned_to_options(with_deleted = false)
    roles = Rails.cache.fetch(:roles) do
      Role.all.order(:name)
    end
    users = Rails.cache.fetch(:users_with_deleted) do
      User.all.with_deleted.order(:first_name, :last_name)
    end

    users = with_deleted ? users : users.reject(&:deleted?)

    {
      'Teams' => roles.map { |role| [role.name, "role-#{role.id}"] },
      'Users' => users.map { |user| [user.name_or_email, "user-#{user.id}"] }
    }
  end

  def construct_teams_options
    roles = Rails.cache.fetch(:roles) do
      Role.all.order(:name)
    end
    {
      'Teams' => roles.map { |role| [role.name, role.id.to_s] }
    }
  end
end
