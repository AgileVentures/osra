FactoryGirl.define do
  factory :orphan_status do
    sequence(:name) { |n| "Name #{n}" }
    sequence(:code)
  end
end
