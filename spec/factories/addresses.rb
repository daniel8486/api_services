FactoryBot.define do
  factory :address do
    code_postal { "MyString" }
    neighborhood { "MyString" }
    city { "MyString" }
    state { "MyString" }
    street { "MyString" }
    complement { "MyString" }
    point_reference { "MyString" }
    number { 1 }
  end
end
