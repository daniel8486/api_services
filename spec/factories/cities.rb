FactoryBot.define do
  factory :city do
    name { "Teresina" }
    association :state
  end
end
