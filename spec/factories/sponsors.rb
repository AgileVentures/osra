FactoryGirl.define do

  COUNTRIES = ISO3166::Country.countries.map {|c| c[1]} - ['IL']

  sequence :countries, (0..COUNTRIES.count).cycle do |n|
    COUNTRIES[n]
  end

  factory :sponsor do
    name { Faker::Name.name }
    requested_orphan_count (1..10).to_a.sample
    country { generate :countries }
<<<<<<< HEAD
    gender { %w(Male Female).sample }
    payment_plan { Sponsor::PAYMENT_PLANS.sample }
    sponsor_type { SponsorType.all[[0,1].sample] }
    branch { FactoryGirl.create(:branch) if sponsor_type.name == 'Individual' }
    organization { FactoryGirl.create(:organization) if sponsor_type.name == 'Organization' }
<<<<<<< HEAD
  end 
=======
    payment_plan { Settings.payment_plans.sample }
=======
    gender { Settings.lookup.gender.sample }
    sponsor_type { SponsorType.all[[0,1].sample] }
    branch { FactoryGirl.create(:branch) if sponsor_type.name == 'Individual' }
    organization { FactoryGirl.create(:organization) if sponsor_type.name == 'Organization' }
>>>>>>> merge conflicts, part deux
    payment_plan { Sponsor::PAYMENT_PLANS.sample }
  end
>>>>>>> add payment_plan to Sponsor factory
end
