require 'rails_helper'

describe Orphan, type: :model do

  it { is_expected.to validate_presence_of :name }

  it { is_expected.to validate_presence_of :name }

  it { is_expected.to validate_presence_of :father_name }

  it { is_expected.to validate_presence_of :father_date_of_death }

  it { is_expected.to allow_value(Date.today - 5,'2011-03-15').for(:father_date_of_death) }

  it { is_expected.to_not allow_value(Date.today + 5).for(:father_date_of_death) }

  it { is_expected.to_not allow_value(7).for(:father_date_of_death) }

  it { is_expected.to_not allow_value('this is not a date value').for(:father_date_of_death) }

  it { is_expected.to_not allow_value(nil).for(:father_is_martyr) }

  it { is_expected.to allow_value(true, false).for(:father_is_martyr) }

  it { is_expected.to validate_presence_of :mother_name }

  it { is_expected.to_not allow_value(nil).for(:mother_alive) }

  it { is_expected.to allow_value(true, false).for(:mother_alive) }

  it { is_expected.to allow_value(Date.today - 5,'2011-03-15').for(:date_of_birth) }

  it { is_expected.to_not allow_value(Date.today + 5).for(:date_of_birth) }

  it { is_expected.to_not allow_value(7).for(:date_of_birth) }

  it { is_expected.to_not allow_value('this is not a date value').for(:date_of_birth) }

  it { is_expected.to validate_presence_of :gender }

  it { is_expected.to allow_value('Male', 'Female').for(:gender) }

  it { is_expected.to_not allow_value('male').for(:gender) }

  it { is_expected.to_not allow_value('female').for(:gender) }

  it { is_expected.to validate_presence_of :contact_number }

  it { is_expected.to_not allow_value(nil).for(:sponsored_by_another_org) }

  it { is_expected.to allow_value(true, false).for(:sponsored_by_another_org) }

  it { is_expected.to validate_numericality_of(:minor_siblings_count).only_integer.is_greater_than_or_equal_to(0) }

  it { is_expected.to validate_presence_of :original_address }

  it { is_expected.to validate_presence_of :current_address }

  it 'date of birth should not be in future' do
    orphan = FactoryGirl.build(:orphan, date_of_birth: 4.days.from_now)
    expect(orphan).to_not be_valid
  end

  it 'fathers date of death should not be in future' do
    orphan = FactoryGirl.build(:orphan, father_date_of_death: 4.days.from_now)
    expect(orphan).to_not be_valid
  end

end
