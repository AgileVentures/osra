FactoryGirl.define do
  factory :sponsorship do
    sponsor
    orphan
    sponsorship_status
    start_date Date.current
  end
end
