FactoryGirl.define do
  factory :province do
    sequence(:name) { |n| "Name #{n}" }
    sequence(:code, 0) do |n|
      valid_codes = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 29]
      valid_codes[n]
    end
  end
end