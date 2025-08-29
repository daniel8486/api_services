FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    sequence(:cnpj) { |n| "123456780001#{format('%02d', n)}" }
  end
end
