FactoryGirl.define do
  factory :organization do
    sequence(:code, 50)
    sequence(:name) {|n| "#{Faker::Company.name} #{n}" }
  end
end
