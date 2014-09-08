FactoryGirl.define do
  factory :organization do
    sequence (:code)
    sequence(:name) { |n| "Organization #{n}" }
    country "United Kingdom"
    region "Europe"
    start_date "2014-09-03"
    status
  end
end
