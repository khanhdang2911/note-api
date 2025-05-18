FactoryBot.define do
  factory :note do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
  end
end
