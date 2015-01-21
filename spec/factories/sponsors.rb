FactoryGirl.define do

  COUNTRIES = ISO3166::Country.countries.map {|c| c[1]} - ['IL']

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

    trait :address_street do
      address { "#{Faker::Address.building_number.to_s} #{Faker::Address.street_name}" }  
    end
    trait :email do
      email { Faker::Internet.email }  
    end
    trait :contact1 do
      contact1 { Faker::PhoneNumber.phone_number }
    end
    trait :contact2 do
      contact2 { Faker::PhoneNumber.cell_phone }
    end
    trait :additional_info do
      additional_info { Faker::Lorem.sentence }
    end

    #randomness: fields presence randomness is generated on each FactoryGirl.reload (or each rspec execution),
    #            not on each FactoryGirl.build.
    trait :random_optional_fields do  
      [true,false].sample and address_street
      [true,false].sample and email
      [true,false].sample and contact1
      [true,false].sample and contact2
      [true,false].sample and additional_info
    end

    factory :sponsor_full, traits: [:address_street, :email, :contact1, :contact2, :additional_info]
    factory :sponsor_random_optional_fields, traits: [:random_optional_fields] 
  end
end



    
    
    
    
    
