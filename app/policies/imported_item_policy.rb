class ImportedItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      @user.assign_role_if_empty
      raise 'Cannot determine scope' unless @user.in_role_name?('sysadmin') || @user.in_role_name?('manager')

      ImportedItem.all
    end
  end

  def index?
    sysadmin? || admin?
  end

  def create?
    sysadmin? || admin?
  end
end
