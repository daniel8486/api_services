FactoryBot.define do
  factory :neighborhood do
    name { "MyString" }
    city { create(:city) }
  end
end
