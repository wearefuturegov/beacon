class NoteCategoryPolicy < ApplicationPolicy
  def index?
    admin? || sysadmin?
  end

  def update?
    admin? || sysadmin?
  end

  def destroy?
    admin? || sysadmin?
  end

  def create?
    admin? || sysadmin?
  end
end
