class ImportedItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      @user.assign_role_if_empty
      raise 'Cannot determine scope' unless @user.in_role_name?('sysadmin')

      ImportedItem.all
    end
  end

  def index?
    sysadmin?
  end

  def create?
    sysadmin?
  end
end
