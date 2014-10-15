FactoryGirl.define do
  factory :organization do
    sequence(:code, 50)
    name { Faker::Company.name }
  end
end
