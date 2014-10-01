FactoryGirl.define do
  factory :sponsor do
    name { Faker::Name.name }
    requested_orphan_count (0..10).to_a.sample
    country { Faker::Address.country }
    gender { %w(Male Female).sample }
    sponsor_type
    branch
  end
end
