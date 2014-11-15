FactoryGirl.define do
  factory :father do
    name { Faker::Name.name }
    status { %i(dead alive).sample }
    martyr_status { status == :alive ? :not_martyr : %i(not_martyr martyr).sample }

    after(:build, :stub, :create) do |father|
      father.orphan ||= build_stubbed :orphan, father: father
    end
  end

end
