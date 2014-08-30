require 'rails_helper'

RSpec.describe Address, :type => :model do

  before(:each) do
    @address = Address.new
  end

  it "should have a valid province" do
    invalid
    expect(@address.errors[:province].size).to eq(1)

  end

  it "should have a valid city" do
    invalid
    expect(@address.errors[:city].size).to eq(1)
  end

  it "should have a valid neighborhood" do
    invalid
    expect(@address.errors[:neighborhood].size).to eq(1)
  end

  def invalid
    expect(@address).to be_invalid
  end
end
