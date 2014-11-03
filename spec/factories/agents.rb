FactoryGirl.define do
  factory :agent do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email("#{first_name}_#{last_name}") }
  end

end
