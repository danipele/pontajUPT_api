FactoryBot.define do
  factory :course do
    name { Faker::University.name }
    student_year { Faker::Number.between(1, 10) }
    semester { Faker::Number.between(1, 2) }
    faculty { Faker::University.name }
    description { Faker::GameOfThrones.quote }
  end
end
