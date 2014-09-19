FactoryGirl.define do
  factory :sponsor do
    name { Faker::Name.name }
    country { Faker::Address.country }
    gender %w(Male Female).sample
    sponsor_type
  end
end
