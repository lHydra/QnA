class AnswerPolicy < ApplicationPolicy
  attr_reader :user, :answer

  def update?
    record.user == user
  end
end
