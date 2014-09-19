FactoryGirl.define do
  factory :organization do
    sequence(:code)
    name { Faker::Company.name }
    country { Faker::Address.country }
    start_date 6.months.ago
    status
  end
end
