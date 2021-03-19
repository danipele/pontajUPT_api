FactoryBot.define do
  factory :project do
    name { Faker::Science.scientist }
    description { Faker::Friends.quote }
  end
end
