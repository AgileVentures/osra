# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    code 1
    sequence(:name) { |n| "Organization #{n}" }
    country "United Kingdom"
    region "Europe"
    start_date "2014-09-03"
    status_id 1
  end
end
