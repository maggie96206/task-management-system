FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 3) }
    content { Faker::Lorem.paragraph }
    start_at { Time.zone.now }
    end_at { |task| task.start_at + 1.hour }
    priority { "low" }
    status { "pending" }
  end
end
