FactoryBot.define do
  factory :city do
    code { 1 }
    name { "MyString" }
    state { nil }
    latitude { 1.5 }
    longitude { 1.5 }
    capital { false }
    ddd { "MyString" }
    timezone { "MyString" }
  end
end
