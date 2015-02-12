FactoryGirl.define do
  factory :admin_user do
    email "admin@example.com"
    password "password"
    password_confirmation {|u| u.password}
  end
end
