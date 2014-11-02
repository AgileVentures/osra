FactoryGirl.define do
  factory :partner do
    sequence(:name) { |n| "#{Faker::Company.name} #{n}" }
    province { Province.all[(0..13).to_a.sample] }
  end
end
