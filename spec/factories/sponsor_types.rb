FactoryGirl.define do
  factory :sponsor_type do
    sequence(:name) { |n| "Name #{n}" }
    sequence(:code)
  end
end
