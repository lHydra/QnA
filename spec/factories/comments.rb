FactoryBot.define do
  factory :comment do
    body { 'MyString' }
  end

  factory :comment_on_question, class: Comment do
    body { 'MyString' }
    association :commentable, factory: :question
  end

  factory :comment_on_answer, class: Comment do
    body { 'MyString' }
    association :commentable, factory: :answer
  end
end
