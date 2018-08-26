FactoryBot.define do
  sequence :email do |n|
    "user#{n}email@email.ru"
  end

  factory :user do
    email
    password { 'qwerty' }
    password_confirmation { 'qwerty' }
  end
end
