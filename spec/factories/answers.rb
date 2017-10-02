FactoryGirl.define do
  factory :answer do
    user
    body 'MyString'
  end

  factory :invalid_answer, class: Answer do
    body nil
  end
end
