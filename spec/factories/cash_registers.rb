FactoryBot.define do
  factory :cash_register do
    opening_value { "9.99" }
    closing_value { "9.99" }
    opened_at { "2025-06-03 09:52:43" }
    closed_at { "2025-06-03 09:52:43" }
    user { nil }
  end
end
