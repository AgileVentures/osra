FactoryGirl.define do
  factory :father do
    name { Faker::Name.name }
    status { %i(dead alive).sample }
    martyr_status { status == :alive ? :not_martyr : %i(not_martyr martyr).sample }
    date_of_death { 6.months.ago if status == :dead }

    after(:build, :stub, :create) do |father|
      father.orphan ||= build_stubbed :orphan, father: father
    end
  end

end
