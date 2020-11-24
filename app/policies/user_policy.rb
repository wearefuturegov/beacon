class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  [:update?, :create?, :destroy?, :restore?].each do |m|
    define_method(m) { sysadmin? }
  end
end
