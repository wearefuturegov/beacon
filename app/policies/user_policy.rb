class UserPolicy < ApplicationPolicy
  [:index?, :update?, :create?].each do |m|
    define_method(m) { admin? }
  end
end
