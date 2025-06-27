FactoryBot.define do
  factory :installment do
    contract { nil }
    numero { 1 }
    valor { "9.99" }
    vencimento { "2025-06-01" }
    data_pagamento { "2025-06-01" }
    status { "MyString" }
  end
end
