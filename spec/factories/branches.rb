FactoryGirl.define do
  factory :branch do
    sequence(:name) { |n| "OSRA Branch # #{n}" }
    sequence(:code)
  end
end
