class UserPolicy < ApplicationPolicy
  [:index?, :update?, :create?].each do |m|
    define_method(m) { admin? }
  end

  def destroy?
    # only admins can destroy
    return true if admin?
  end
end
