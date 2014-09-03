FactoryGirl.define do
  factory :province do
    sequence(:name) { |n| "Province #{n}" }
    sequence(:code, 0) { |n| Province::PROVINCE_CODES[n] }
  end
end
