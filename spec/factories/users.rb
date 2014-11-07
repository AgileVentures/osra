FactoryGirl.define do
  factory :user do
    sequence(:user_name) { |n| "#{Faker::Name.name} #{n}" }
    email { Faker::Internet.email("#{user_name}") }
  end
end
