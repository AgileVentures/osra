FactoryGirl.define do
  factory :organization do
    sequence(:code)
    name { Faker::Company.name }
  end
end
