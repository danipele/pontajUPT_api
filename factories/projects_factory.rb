FactoryBot.define do
  factory :project do
    name { Faker::Science.scientist }
    description { Faker::Science.element }
  end
end
