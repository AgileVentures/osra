FactoryGirl.define do
  factory :agent do
    agent_name { Faker::Name.name}
    email { Faker::Internet.email("#{agent_name}") }
  end

end
