FactoryGirl.define do
  factory :orphan do
    name { Faker::Name.first_name }
    father_given_name { Faker::Name.first_name }
    mother_name { Faker::Name.first_name  }
    family_name { Faker::Name.last_name }
    date_of_birth { 10.years.ago }
    #father_is_martyr { [true, false].sample }
    #father_date_of_death { 4.days.ago }
    father_is_martyr { false }
    mother_alive { [true, false].sample }
    #TODO return father_alive back to [true, false].sample
    #father_alive { [true, false].sample }
    #date_of_birth { 10.years.ago }
    father_alive { true }
    gender { %w(Male Female).sample }
    contact_number { Faker::PhoneNumber.phone_number }
    sponsored_by_another_org { [true, false].sample }
    minor_siblings_count { (0..5).to_a.sample }
    sponsored_minor_siblings_count { (0..minor_siblings_count).to_a.sample }
    association :original_address, factory: :address
    association :current_address, factory: :address
    orphan_list
  end
end
