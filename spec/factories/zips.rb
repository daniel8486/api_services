FactoryBot.define do
  factory :zip do
    code { "MyString" }
    street { "MyString" }
    association :neighborhood
    association :city
  end
end
