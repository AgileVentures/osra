require 'rails_helper'

describe Orphan, type: :model do

  before(:each) do
    @orphan = Orphan.new
  end

  it "should have a valid name" do
    invalid
    expect(@orphan.errors[:name].size).to eq(1)
  end

  it "should have a valid father name" do
    invalid
    expect(@orphan.errors[:father_name].size).to eq(1)
  end

  it "should have a value for father is martyr?" do
    invalid
    expect(@orphan.errors[:father_is_martyr].size).to eq(1)
  end

  it "should allow true value for father is martyr?" do
    @orphan.father_is_martyr = true
    expect(@orphan.errors[:father_is_martyr].size).to eq(0)
  end

  it "should allow false value for father is martyr?" do
    @orphan.father_is_martyr = false
    expect(@orphan.errors[:father_is_martyr].size).to eq(0)
  end

  it "should have a valid father date of death" do
    invalid
    expect(@orphan.errors[:father_date_of_death].size).to be >= 1
  end

  it "should not allow a value for father date of death that is not a date" do
    @orphan.father_date_of_death = 3
    invalid
    expect(@orphan.errors[:father_date_of_death].size).to eq(1)
  end

  it "should not allow a future date for father date of death" do
    @orphan.father_date_of_death = '2050-01-01'
    invalid
    expect(@orphan.errors[:father_date_of_death].size).to eq(1)
  end

  it "should allow a date value for father date of death" do
    @orphan.father_date_of_death = Date.today
    expect(@orphan.errors[:father_date_of_death].size).to eq(0)
  end

  it "should allow a valid string value for father date of death" do
    @orphan.father_date_of_death = '2014-08-13'
    expect(@orphan.errors[:father_date_of_death].size).to eq(0)
  end

  it "should have a valid mother name" do
    invalid
    expect(@orphan.errors[:mother_name].size).to eq(1)
  end

  it "should allow true value for mother alive?" do
    @orphan.mother_alive = true
    expect(@orphan.errors[:mother_alive].size).to eq(0)
  end

  it "should allow false value for mother alive?" do
    @orphan.mother_alive = false
    expect(@orphan.errors[:mother_alive].size).to eq(0)
  end

  it "should have a valid date of birth" do
    invalid
    expect(@orphan.errors[:date_of_birth].size).to be >= 1
  end

  it "should not allow a future date for date of birth" do
    @orphan.date_of_birth = '2050-01-01'
    invalid
    expect(@orphan.errors[:date_of_birth].size).to eq(1)
  end

  it "should have a valid gender" do
    invalid
    expect(@orphan.errors[:gender].size).to eq(1)
  end

  it "should have a valid contact number" do
    invalid
    expect(@orphan.errors[:contact_number].size).to eq(1)
  end

  it "should allow true value for sponsored by another org?" do
    @orphan.sponsored_by_another_org = true
    expect(@orphan.errors[:sponsored_by_another_org].size).to eq(0)
  end

  it "should allow false value for sponsored by another org?" do
    @orphan.sponsored_by_another_org = false
    expect(@orphan.errors[:sponsored_by_another_org].size).to eq(0)
  end

  it "should have a valid minor siblings count" do
    invalid
    expect(@orphan.errors[:minor_siblings_count].size).to be >= 1
  end

  it "should not allow a float as minor siblings count" do
    @orphan.minor_siblings_count = 1.1
    invalid
    expect(@orphan.errors[:minor_siblings_count].size).to eq(1)
  end

  it "should not allow a negative number as minor siblings count" do
    @orphan.minor_siblings_count = -2
    invalid
    expect(@orphan.errors[:minor_siblings_count].size).to eq(1)
  end

  it "should have a valid original address" do
    invalid
    expect(@orphan.errors[:original_address].size).to eq(1)
  end

  it "should have a valid current address" do
    invalid
    expect(@orphan.errors[:current_address].size).to eq(1)
  end

  def invalid
    expect(@orphan).to be_invalid
  end

end
