require 'rails_helper'

describe Orphan, type: :model do

  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:father_name) }

  it { should validate_presence_of(:father_date_of_death) }

  it { should allow_value(Date.today - 5,'2011-03-15').for(:father_date_of_death) }

  it { should_not allow_value(Date.today + 5).for(:father_date_of_death) }

  it { should_not allow_value(7).for(:father_date_of_death) }

  it { should_not allow_value('this is not a date value').for(:father_date_of_death) }

  it { should_not allow_value(nil).for(:father_is_martyr) }

  it { should allow_value(true, false).for(:father_is_martyr) }

  it { should validate_presence_of(:mother_name) }

  it { should_not allow_value(nil).for(:mother_alive) }

  it { should allow_value(true, false).for(:mother_alive) }

  it { should allow_value(Date.today - 5,'2011-03-15').for(:date_of_birth) }

  it { should_not allow_value(Date.today + 5).for(:date_of_birth) }

  it { should_not allow_value(7).for(:date_of_birth) }

  it { should_not allow_value('this is not a date value').for(:date_of_birth) }

  it { should validate_presence_of(:gender) }

  it { should allow_value('Male', 'Female').for(:gender) }

  it { should_not allow_value('male').for(:gender) }

  it { should_not allow_value('female').for(:gender) }

  it { should validate_presence_of(:contact_number) }

  it { should_not allow_value(nil).for(:sponsored_by_another_org) }

  it { should allow_value(true, false).for(:sponsored_by_another_org) }

  it { should validate_numericality_of(:minor_siblings_count).only_integer.is_greater_than_or_equal_to(0) }

  it { should validate_presence_of(:original_address) }

  it { should validate_presence_of(:current_address) }

end
