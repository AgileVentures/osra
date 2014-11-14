FactoryGirl.define do
  factory :father do
    name { Faker::Name.name }
    is_alive? { [true, false].sample }
    date_of_death { is_alive? ? nil : 6.months.ago }
  end

end
