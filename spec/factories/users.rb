FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "123456" }
    cpf { "12345678901" }
    role { :user }
    association :company
  end
end
