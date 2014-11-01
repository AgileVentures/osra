FactoryGirl.define do

  COUNTRIES = ISO3166::Country.countries.map {|c| c[1]} - ['IL']

  sequence :countries, (0..COUNTRIES.count).cycle do |n|
    COUNTRIES[n]
  end

  factory :sponsor do
    name { Faker::Name.name }
    requested_orphan_count (1..10).to_a.sample
    country { generate :countries }
    gender { %w(Male Female).sample }
    payment_plan { Settings.payment_plans.sample }
    sponsor_type
    branch
    payment_plan { Sponsor::PAYMENT_PLANS.sample }
  end
end
