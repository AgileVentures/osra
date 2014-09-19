FactoryGirl.define do
  factory :partner do
    name { Faker::Company.name }
    province
  end
end
