class NeedPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      case @user.role_type
      when 'manager', 'agent'
        Need.all
      when 'mdt'
        Need.where(category: 'phone triage')
      when 'food_delivery_manager'
        Need.where(category: 'groceries and cooked meals')
      else
        Need.where(id: -1)
      end
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
end