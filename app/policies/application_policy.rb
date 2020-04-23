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

  protected

  def admin?
    @user.in_role_name?('manager')
  end

  def agent?
    @user.in_role_name?('agent')
  end

  def mdt?
    @user.in_role_name?('mdt')
  end

  def council_service?
    @user.role.role.start_with? 'council_service_'
  end

  def all_roles?
    admin? || agent? || mdt? || council_service? || @user.in_role_name?('food_delivery_manager')
  end
end
