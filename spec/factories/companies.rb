FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    cnpj { Faker::Company.unique.brazilian_company_number } # usa CPF/CNPJ válidos

    # Se você estiver validando unicidade no model:
    sequence(:cnpj) { |n| "12.345.678/0001-#{format('%02d', n)}" }
  end
end
