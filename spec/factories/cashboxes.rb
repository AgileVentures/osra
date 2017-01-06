FactoryGirl.define do
  factory :cashbox do
    balance { FactoryHelper::MySQL.integer  }
  end

end
