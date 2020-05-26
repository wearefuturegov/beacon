class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
    @user.assign_role_if_empty
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  def display_support_actions?
    mdt_council_or_food_role? ? false : true
  end

  def mdt?
    @user.in_role_name?('mdt')
  end

  def admin?
    @user.in_role_name?('manager')
  end

  def sysadmin?
    @user.in_role_name?('sysadmin')
  end

  protected

  def agent?
    @user.in_role_name?('agent')
  end

  def council_service?
    @user.role.role.start_with? 'council_service_'
  end

  # these roles have trusted access to the system
  # even if their list view is restricted, they can
  # still see items via other means
  def permissive_roles?
    admin? || agent? || mdt? || council_service?
  end

  def all_roles?
    permissive_roles? || @user.in_role_name?('food_delivery_manager')
  end

  private

  def mdt_council_or_food_role?
    council_service_roles.any? { |role| @user.in_role_name?(role.tag) } ||
      user_is_in_mdt_role? ||
      food_manager?
  end

  def council_service_roles
    Role.where("role like 'council_service%'")
  end

  def user_is_in_mdt_role?
    @user.in_role_name?('mdt')
  end

  def food_manager?
    @user.in_role_name?('food_delivery_manager')
  end
end
