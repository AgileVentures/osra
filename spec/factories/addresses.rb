FactoryGirl.define do
  factory :address do
    province { Province.first }
    city { Faker::Address.city }
    neighborhood { Faker::Address.street_name }
    street { Faker::Address.street_address }
  end
end
