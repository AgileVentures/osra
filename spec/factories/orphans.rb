FactoryGirl.define do
  factory :orphan do
    name { Faker::Name.name }
    father_name { Faker::Name.name }
    father_is_martyr { [true, false].sample }
    father_date_of_death { 4.days.ago }
    mother_name { Faker::Name.name  }
    mother_alive { [true, false].sample }
    date_of_birth { 10.years.ago }
    gender { %w(Male Female).sample }
    contact_number { Faker::PhoneNumber.phone_number }
    sponsored_by_another_org { [true, false].sample }
    minor_siblings_count { (0..5).to_a.sample }
    association :original_address, factory: :address
    association :current_address, factory: :address
  end
end
