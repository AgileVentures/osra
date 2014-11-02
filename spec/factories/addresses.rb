FactoryGirl.define do
  factory :address do
    province { Province.all[(0..13).to_a.sample] }
    city { Faker::Address.city }
    neighborhood { Faker::Address.street_name }
    street { Faker::Address.street_address }
  end
end
