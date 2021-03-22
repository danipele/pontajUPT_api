FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    type { ['Angajat cu norma de baza', 'Angajat in regim de plata cu ora', 'Colaborator'].sample }
  end
end
