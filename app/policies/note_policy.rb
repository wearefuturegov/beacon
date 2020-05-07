class NotePolicy < ApplicationPolicy
  def index?
    true
  end

  def update?
    true
  end

  def show?
    true
  end

  def destroy?
    return true if admin?

    Pundit.policy_scope!(@user, Note).where(id: @record.id, user_id: @user.id).exists?
  end

  def create?
    true
  end
end
