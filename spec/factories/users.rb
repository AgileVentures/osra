FactoryGirl.define do
  factory :user do
    user_name { Faker::Name.name}
    email { Faker::Internet.email("#{user_name}") }
  end

end
