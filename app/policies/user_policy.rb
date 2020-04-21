class UserPolicy < ApplicationPolicy

  [:index?, :update?, :create?].each do |m|
    define_method(m) { is_admin? }
  end
end