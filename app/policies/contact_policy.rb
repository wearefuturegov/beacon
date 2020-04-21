class ContactPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      Contact.all
      # todo this is placeholder code until we understand requirements
      case @user.role_type
      when 'manager', 'agent'
        Contact.all
      when 'mdt'
        # todo: MDT need?
        Contact.joins(:needs).where(needs: { category: 'phone triage' })
      when 'food_delivery_manager'
        Contact.where(id: -1)
      else
        Contact.where(id: -1)
      end
    end
  end

  def index?
    is_admin?
  end

  def update?
    is_admin?
  end

  def show?
    is_admin?
  end
end