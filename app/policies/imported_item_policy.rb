class ImportedItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if @user.in_role_name?('manager')
        ImportedItem.all
      else
        raise "Cannot determine scope"
      end
    end
  end
  
  def index?
    admin?
  end
end