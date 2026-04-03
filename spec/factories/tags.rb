FactoryBot.define do
  factory :tag do
    name { "標籤1" }
    association :user
  end
end
