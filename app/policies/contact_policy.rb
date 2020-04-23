class ContactPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      @user.assign_role_if_empty
      case @user.role
      when 'manager', 'agent'
        Contact.all
      else
        raise "Cannot determine contact scope for role #{@user.role.name}"
      end
    end
  end

  def index?
    @user.in_role_names?(%w(manager agent mdt food_delivery_manager))
  end

  def update?
    admin? || agent? || mdt?
  end

  def show?
    @user.in_role_names?(%w(manager agent mdt food_delivery_manager))
  end

  def create?
    admin? || agent? || mdt?
  end
end
