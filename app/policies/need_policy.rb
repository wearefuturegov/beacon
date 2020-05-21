class NeedPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      @user.assign_role_if_empty
      case @user.role.tag
      when 'manager', 'agent'
        @scope
      when 'mdt'
        needs_me_or_role 'mdt'
      when 'food_delivery_manager'
        needs_me_role_team 'food_delivery_manager'
      when ->(r) { r.start_with? 'council_service_' }
        needs_me_role_team @user.role.tag
      else
        raise "Cannot determine need scope for role #{@user.role.name} #{@user.role.tag}"
      end
    end

    def needs_me_or_role(role_tag)
      @scope.where(id: Need.includes(:role)
            .where(roles: { tag: role_tag })
            .or(Need.includes(:role).where(user: @user)))
    end

    def needs_me_role_team(role_tag)
      @scope.where(id: Need.includes(:role, user: [:roles])
                           .where(roles: { tag: role_tag })
                           .or(Need.includes(:role, user: [:roles]).where(user: @user))
                           .or(Need.includes(:role, user: [:roles]).where("roles_users.role = '#{role_tag}'")))
    end
  end

  def index?
    true
  end

  def update?
    return true if permissive_roles?

    Pundit.policy_scope!(@user, Need).where(id: @record.id).exists?
  end

  def show?
    return true if permissive_roles?

    Pundit.policy_scope!(@user, Need).where(id: @record.id).exists?
  end

  def destroy?
    # managers can always destroy
    return true if admin?

    # check ownership of need record
    need = Need.where(id: @record.id).created_by(@user.id)
    return need.first.no_notes_by_somebody_else?(@user.id) if need.exists?

    false
  end

  def create?
    permissive_roles?
  end

  def bulk_action?
    update?
  end

  def export?
    admin? || food_manager?
  end

  def dashboard_change_multiple?
    return true if permissive_roles?
  end

  def start_assessment?
    Need.where(id: @record.id, user_id: @user.id).exists?
  end

end
