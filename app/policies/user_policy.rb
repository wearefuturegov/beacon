class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  [:update?, :create?, :destroy?].each do |m|
    define_method(m) { sysadmin? }
  end
end
