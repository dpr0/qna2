FactoryGirl.define do


  factory :user do
    sequence(:email) { |i| "user#{i}@yandex.ru" }
    password "123456"
    password_confirmation "123456"
  end

end
