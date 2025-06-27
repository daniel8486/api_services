FactoryBot.define do
  factory :campaign do
    name { "MyString" }
    description { "MyText" }
    company { nil }
    plan { nil }
    discount_percentage { "9.99" }
    payment_method { "MyString" }
  end
end
