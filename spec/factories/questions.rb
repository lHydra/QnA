FactoryGirl.define do
  factory :question do
    user
    title 'Some title'
    body 'Some body'
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end
end
