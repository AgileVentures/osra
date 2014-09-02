FactoryGirl.define do
  factory :province do
    sequence(:name) { |n| "Province #{n}" }
    sequence(:code, Province::PROVINCE_CODES.to_enum)
  end
end
