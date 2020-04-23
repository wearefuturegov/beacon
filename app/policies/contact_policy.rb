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
        contacts_me_role_team'food_delivery_manager'
      when 'service_member'
        contacts_me_role_team 'service_member'
      else
        raise "Cannot determine contact scope for role #{@user.role.name}"
      end
    end

    def contacts_me_or_role(role_tag)
      Contact.joins(:needs)
          .left_joins(:needs => [:user])
          .left_joins(:needs => [:role])
          .where("user_id = #{@user.id} or roles.role = '#{role_tag}'")
    end

    def contacts_me_role_team(role_tag)
      Contact.joins(:needs)
          .left_joins(:needs => [{:user => [:roles] }])
          .left_joins(:needs => [:role])
          .where("users.id = #{@user.id} or roles_needs.role = '#{role_tag}' or roles.role = '#{role_tag}'")
          .distinct
    end
  end

  def index?
    @user.in_role_names?(%w(manager agent mdt food_delivery_manager service_member))
  end

  def update?
    admin? || agent? || mdt? || @user.in_role_name?('service_member')
  end

  def show?
    @user.in_role_names?(%w(manager agent mdt food_delivery_manager service_member))
  end

  def create?
    admin? || agent? || mdt?
  end
end
