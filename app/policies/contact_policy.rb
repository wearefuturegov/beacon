class ContactPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      @user.assign_role_if_empty
      @user.in_role_names?(%w[manager agent]) ? Contact.all : Contact.where(id: -1)
    end
  end

  def index?
    admin?
  end

  def update?
    admin?
  end

  def show?
    admin?
  end

  def create?
    admin?
  end
end
