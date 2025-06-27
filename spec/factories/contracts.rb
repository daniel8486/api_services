FactoryBot.define do
  factory :contract do
    client_id { 1 }
    plan { nil }
    campaign { nil }
    details { "MyString" }
  end
end
