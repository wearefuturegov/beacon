class NeedPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      @user.in_role_names?(%w(manager agent)) ? Need.all : Need.where(id: -1)
    end
  end

  def index?
    is_admin?
  end

  def update?
    is_admin?
  end

  def show?
    is_admin?
  end

  def create?
    is_admin?
  end
end