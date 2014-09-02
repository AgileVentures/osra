FactoryGirl.define do
  factory :orphan do
    name { Faker::Name.name }
    father_name { Faker::Name.name }
    father_is_martyr true
    father_date_of_death { 4.days.ago }
    mother_name { Faker::Name.name  }
    mother_alive false
    date_of_birth { 10.years.ago }
    gender 'Female'
    contact_number { Faker::PhoneNumber.phone_number }
    sponsored_by_another_org true
    minor_siblings_count 3
    association :original_address, factory: :address
    association :current_address, factory: :address
  end
end
