module SideNavHelper
  def display_support_actions?
    mdt_council_or_food_role? ? false : true
  end

  private

  def mdt_council_or_food_role?
    council_service_roles.any? { |role| current_user.in_role_name?(role.tag) } ||
      user_is_in_mdt_role? ||
      user_is_in_food_role?
  end

  def council_service_roles
    Role.where("role like 'council_service%'")
  end

  def user_is_in_mdt_role?
    current_user.in_role_name?('mdt')
  end

  def user_is_in_food_role?
    current_user.in_role_name?('food_delivery_manager')
  end
end
