FactoryGirl.define do
  factory :sponsorship do
    start_date { Date.current }
    sponsor
    orphan
  end
end
