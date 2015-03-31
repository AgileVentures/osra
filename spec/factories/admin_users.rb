FactoryGirl.define do
  factory :admin_user do
    sequence(:email) { |n| "#{n}#{Faker::Internet.email}" }
    password { Faker::Internet.password }
    password_confirmation { |u| u.password }
  end
end
