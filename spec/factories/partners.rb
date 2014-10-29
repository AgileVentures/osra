FactoryGirl.define do
  factory :partner do
    sequence(:name) { |n| "#{Faker::Company.name} #{n}" }
    province
  end
end
