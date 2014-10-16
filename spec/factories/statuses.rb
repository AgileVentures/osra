FactoryGirl.define do
  factory :status do
    sequence(:name) { |n| "Name #{n}" }
    sequence(:code)
  end
end