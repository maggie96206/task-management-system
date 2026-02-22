FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 3) }
    content { Faker::Lorem.paragraph }
    start_at { Time.zone.now }
    end_at { Time.zone.now + 1.hour }
    priority { 3 }
    status { 0 }
  end
end
