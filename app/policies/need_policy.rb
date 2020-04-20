class NeedPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      Need.all
    end
  end
end