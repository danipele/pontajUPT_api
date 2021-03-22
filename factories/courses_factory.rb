FactoryBot.define do
  factory :course do
    name { Faker::University.name }
    student_year { Faker::Number.between(1, 10) }
    semester { Faker::Number.between(1, 2) }
    cycle { %i[Licenta Master Doctorat].sample }
    faculty { Faker::University.name }
    description { Faker::Game.genre }
  end
end
