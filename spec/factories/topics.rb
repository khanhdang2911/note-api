FactoryBot.define do
  factory :topic do
    name { Faker::Lorem.words(number: 10).join(" ") }
    description { Faker::Lorem.sentence }
  end
end
