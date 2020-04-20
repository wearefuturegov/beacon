class UserPolicy < ApplicationPolicy

  [:index?, :update?].each do |m|
    define_method(m) { is_admin? }
  end
end