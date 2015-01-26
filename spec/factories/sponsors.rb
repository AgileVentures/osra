FactoryGirl.define do

  COUNTRIES = ISO3166::Country.countries.map {|c| c[1]} - Sponsor::EXCLUDED_COUNTRYS

  sequence :countries, (0..(COUNTRIES.count - 1)).cycle do |n|
    COUNTRIES[n]
  end

  factory :sponsor do
    name { Faker::Name.name }
    requested_orphan_count (1..10).to_a.sample
    country { generate :countries }
    city { Faker::Address.city }
    gender { %w(Male Female).sample }
    sponsor_type { SponsorType.all[[0,1].sample] }
    branch { Branch.all.sample if sponsor_type.name == 'Individual' }
    organization { Organization.all.sample if sponsor_type.name == 'Organization' }
    payment_plan { Sponsor::PAYMENT_PLANS.sample }
    agent

    trait :random_optional_fields do  
      address { ["#{Faker::Address.building_number.to_s} #{Faker::Address.street_name}", nil].sample }
      email { [Faker::Internet.email, nil].sample }
      contact1 { [Faker::PhoneNumber.phone_number, nil].sample }
      contact2 { [Faker::PhoneNumber.cell_phone, nil].sample }
      additional_info { [Faker::Lorem.sentence, nil].sample }
    end

    factory :sponsor_full, traits: [:random_optional_fields] 
  end
end
