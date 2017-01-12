FactoryGirl.define do
  factory :orphan do
    name { Faker::Name.first_name }
    date_of_birth { 10.years.ago }
    gender { %w(Male Female).sample }
    contact_number { Faker::PhoneNumber.phone_number }
    father_given_name { Faker::Name.first_name }
    mother_name { Faker::Name.first_name }
    family_name { Faker::Name.last_name }
    father_deceased { [true, false].sample }
    father_is_martyr { father_deceased ? [true, false].sample : false }
    father_date_of_death { father_deceased ? 4.days.ago : nil }
    mother_alive { [true, false].sample }
    sponsored_by_another_org { [true, false].sample }
    minor_siblings_count { (0..5).to_a.sample }
    sponsored_minor_siblings_count { (0..minor_siblings_count).to_a.sample }
    association :original_address, factory: :address
    association :current_address, factory: :address
    orphan_list

    trait :random_optional_fields do
      status { Orphan.statuses.values.sample }
      sponsorship_status { Orphan.sponsorship_statuses.values.sample }
      health_status { Faker::Lorem.words(3).join(" ") }
      schooling_status { Faker::Lorem.word }
      goes_to_school { [true, false].sample }
      created_at { 2.years.ago }
      updated_at { 1.years.ago }
      father_occupation { Faker::Lorem.word }
      father_place_of_death { Faker::Lorem.word if father_deceased }
      father_cause_of_death { Faker::Lorem.word if father_deceased }
      guardian_name { Faker::Name.first_name }
      guardian_relationship { Faker::Lorem.word }
      guardian_id_num { Faker::Number.number(5).to_i }
      alt_contact_number { Faker::PhoneNumber.phone_number }
      comments { Faker::Lorem.paragraph.truncate(250) }
      province_code { Province.all.sample.code }
    end

    factory :orphan_full, traits: [:random_optional_fields]
  end
end
