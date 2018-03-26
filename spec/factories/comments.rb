FactoryGirl.define do
  factory :comment do
    body "MyString"
    commentable_id 1
    commentable_type "MyString"
  end
end
