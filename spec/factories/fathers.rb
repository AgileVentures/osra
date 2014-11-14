FactoryGirl.define do
  factory :father do
    name { Faker::Name.name }
    status { %i(dead alive).sample }
    martyr_status { status == :alive ? :not_martyr : %i(not_martyr martyr).sample }
    date_of_death { status == :alive ? nil : 6.months.ago }
  end

end
