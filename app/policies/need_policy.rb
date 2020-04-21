class NeedPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      @user.in_role_names?(%w[manager agent]) ? Need.all : Need.where(id: -1)
    end
  end

  def index?
    admin?
  end

  def update?
    admin?
  end

  def show?
    admin?
  end

  def create?
    admin?
  end
end
