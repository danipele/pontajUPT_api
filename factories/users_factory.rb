FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    encrypted_password { Faker::Internet.password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    type { %i[base_norm_employee hourly_basis_employee collaborator].sample }
  end
end
