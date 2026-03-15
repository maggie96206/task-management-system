FactoryBot.define do
  factory :user do
    name { "測試者" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
