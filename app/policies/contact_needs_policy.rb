class ContactNeedsPolicy < ApplicationPolicy
  class Scope < NeedPolicy::Scope
    def resolve
      @user.assign_role_if_empty
      case @user.role.tag
      when 'manager', 'agent', 'mdt'
        @scope
      when 'food_delivery_manager'
        needs_me_role_team 'food_delivery_manager'
      when ->(r) { r.start_with? 'council_service_' }
        @scope
      else
        raise "Cannot determine need scope for role #{@user.role.name} #{@user.role.tag}"
      end
    end
  end
end
