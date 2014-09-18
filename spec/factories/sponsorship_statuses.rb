FactoryGirl.define do
  factory :sponsorship_status do
    sequence(:code)
    sequence(:name) { |n| "SponsorshipStatus#{n}" }
  end
end
