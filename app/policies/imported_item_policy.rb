class ImportedItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise 'Cannot determine scope' unless @user.in_role_name?('manager')

      ImportedItem.all
    end
  end

  def index?
    admin?
  end

  def create?
    admin?
  end
end
