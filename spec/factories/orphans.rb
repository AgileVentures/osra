FactoryGirl.define do
  factory :orphan do
    name { Faker::Name.name }
    father_name { Faker::Name.name }
    father_is_martyr { false }
    mother_name { Faker::Name.name  }
    mother_alive { [true, false].sample }
    father_alive { true }
    date_of_birth { 10.years.ago }
    gender { %w(Male Female).sample }
    contact_number { Faker::PhoneNumber.phone_number }
    sponsored_by_another_org { [true, false].sample }
    minor_siblings_count { (0..5).to_a.sample }
    association :original_address, factory: :address
    association :current_address, factory: :address
    orphan_list
  end
end
