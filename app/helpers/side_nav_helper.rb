module SideNavHelper
  def display_support_actions?
    !user_is_mdt_or_council_service?
  end

  private

  def user_is_mdt_or_council_service?
    council_service_roles.any? { |role| current_user.in_role_name?(role.tag) } || user_is_in_mdt_role?
  end

  def council_service_roles
    Role.where("role like 'council_service%'")
  end

  def user_is_in_mdt_role?
    current_user.in_role_name?('mdt')
  end
end