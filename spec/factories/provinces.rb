FactoryGirl.define do
  factory :province do
    sequence(:name) { |n| "Province #{n}" }
    sequence(:code, 10)
  end
end
