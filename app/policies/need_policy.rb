class NeedPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      current_role = current_user_role.role
      case current_role
      when 'manager', 'agent'
        Need.all
      when 'mdt'
        Need.where(category: 'phone triage')
      when 'food_delivery_manager'
        Need.where(category: 'groceries and cooked meals')
      end
    end
  end
end