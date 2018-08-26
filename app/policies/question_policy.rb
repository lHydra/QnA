class QuestionPolicy < ApplicationPolicy
  def edit?
    record.user == user
  end

  def update?
    record.user_id == user.id
  end

  def destroy?
    edit?
  end
end
