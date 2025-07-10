FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    address { Faker::Address.full_address }
    password { "12345678" }
    password_confirmation { "12345678" }
    refresh_token { "#{SecureRandom.hex(10)}" }
  end
end
