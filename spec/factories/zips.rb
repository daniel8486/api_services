FactoryBot.define do
  factory :zip do
    code { "MyString" }
    street { "MyString" }
    neighborhood { nil }
    city { nil }
  end
end
