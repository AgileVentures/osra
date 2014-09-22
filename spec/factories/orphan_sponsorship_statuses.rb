FactoryGirl.define do
  factory :orphan_sponsorship_status do
    sequence(:code)
    sequence(:name) { |n| "OSS#{n}" }
  end
end
