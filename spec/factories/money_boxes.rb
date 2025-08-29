FactoryBot.define do
  factory :money_box do
    opening_value { "9.99" }
    closing_value { "9.99" }
    user { nil }
    withdrawal_cash { "9.99" }
    observation { "MyText" }
  end
end
