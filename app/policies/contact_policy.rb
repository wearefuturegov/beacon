class ContactPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      @user.assign_role_if_empty
      case @user.role.tag
      when 'manager', 'agent'
        Contact.all
      when 'mdt'
        contacts_me_or_role 'mdt'
      when 'food_delivery_manager'
        contacts_me_role_team 'food_delivery_manager'
      when ->(r) { r.start_with? 'council_service_' }
        contacts_me_role_team @user.role.tag
      else
        raise "Cannot determine contact scope for role #{@user.role.name}"
      end
    end

    def contacts_me_or_role(role_tag)
      Contact.joins(:needs)
             .left_joins(needs: [:user])
             .left_joins(needs: [:role])
             .where("user_id = #{@user.id} or roles.role = '#{role_tag}'")
              .distinct
    end

    def contacts_me_role_team(role_tag)
      Contact.joins(:needs)
             .left_joins(needs: [{ user: [:roles] }])
             .left_joins(needs: [:role])
             .where("users.id = #{@user.id} or roles_needs.role = '#{role_tag}' or roles.role = '#{role_tag}'")
             .distinct
    end
  end

  def index?
    all_roles?
  end

  def update?
    permissive_roles?
  end

  def show?
    return true if permissive_roles?

    Pundit.policy_scope!(@user, Contact).where(id: @record.id).exists?
  end

  def create?
    admin? || agent? || mdt? || council_service?
  end
end
