FactoryBot.define do
  factory :cash_register_transaction do
    cash_register { nil }
    installment { nil }
    client { nil }
    valor { "9.99" }
    tipo { "MyString" }
    data { "2025-06-03 09:53:22" }
  end
end
