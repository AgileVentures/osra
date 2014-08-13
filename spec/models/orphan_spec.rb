require 'spec_helper'

describe Orphan do
  before(:each) do
    @orphan = Orphan.new
  end

  it "should have a valid name" do
    expect(@orphan).to be_invalid
    expect(@orphan).to have(1).error_on(:name)
  end

  it "should have a valid father name" do
    expect(@orphan).to be_invalid
    expect(@orphan).to have(1).error_on(:father_name)
  end

  it "should have a value for father is martyr?" do
    expect(@orphan).to be_invalid
    expect(@orphan).to have(1).error_on(:father_is_martyr)
  end

  it "should allow true value for father is martyr?" do
    @orphan[:father_is_martyr] = true
    expect(@orphan).to have(0).errors_on(:father_is_martyr)
  end

  it "should allow false value for father is martyr?" do
    @orphan[:father_is_martyr] = false
    expect(@orphan).to have(0).errors_on(:father_is_martyr)
  end

  it "should have a valid father date of death" do
    expect(@orphan).to be_invalid
    expect(@orphan).to have_at_least(1).error_on(:father_date_of_death)
  end

  it "should not allow a value for father date of death that is not a date" do
    @orphan[:father_date_of_death] = 3
    expect(@orphan).to be_invalid
    expect(@orphan).to have(1).error_on(:father_date_of_death)
  end

  it "should allow a date value for father date of death" do
    @orphan[:father_date_of_death] = Date.today
    expect(@orphan).to have(0).errors_on(:father_date_of_death)
  end

  it "should allow a valid string value for father date of death" do
    @orphan[:father_date_of_death] = '2014-08-13'
    expect(@orphan).to have(0).errors_on(:father_date_of_death)
  end

  it "should have a valid mother name" do
    expect(@orphan).to be_invalid
    expect(@orphan).to have(1).error_on(:mother_name)
  end

  it "should allow true value for mother alive?" do
    @orphan[:mother_alive] = true
    expect(@orphan).to have(0).errors_on(:mother_alive)
  end

  it "should allow false value for mother alive?" do
    @orphan[:mother_alive] = false
    expect(@orphan).to have(0).errors_on(:mother_alive)
  end

  it "should have a valid date of birth" do
    expect(@orphan).to be_invalid
    expect(@orphan).to have(1).error_on(:date_of_birth)
  end

  it "should have a valid gender" do
    expect(@orphan).to be_invalid
    expect(@orphan).to have(1).error_on(:gender)
  end

  it "should have a valid contact number" do
    expect(@orphan).to be_invalid
    expect(@orphan).to have(1).error_on(:contact_number)
  end

  it "should allow true value for sponsored by another org?" do
    @orphan[:sponsored_by_another_org] = true
    expect(@orphan).to have(0).errors_on(:sponsored_by_another_org)
  end

  it "should allow false value for sponsored by another org?" do
    @orphan[:sponsored_by_another_org] = false
    expect(@orphan).to have(0).errors_on(:sponsored_by_another_org)
  end

  it "should have a valid minor siblings count" do
    expect(@orphan).to be_invalid
    expect(@orphan).to have_at_least(1).error_on(:minor_siblings_count)
  end

  it "should not allow a float as minor siblings count" do
    @orphan[:minor_siblings_count] = 1.1
    expect(@orphan).to be_invalid
    expect(@orphan).to have(1).error_on(:minor_siblings_count)
  end

  it "should not allow a negative number as minor siblings count" do
    @orphan[:minor_siblings_count] = -2
    expect(@orphan).to be_invalid
    expect(@orphan).to have(1).error_on(:minor_siblings_count)
  end

end
