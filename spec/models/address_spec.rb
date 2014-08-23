require 'rails_helper'

RSpec.describe Address, :type => :model do

    before(:each) do
      @address = Address.new
    end

    it "should have a valid province" do
      expect(@address).to be_invalid
      expect(@address.errors[:province].size).to eq(1)

    end

    it "should have a valid city" do
      expect(@address).to be_invalid
      expect(@address.errors[:city].size).to eq(1)
    end

    it "should have a valid neighborhood" do
      expect(@address).to be_invalid
      expect(@address.errors[:neighborhood].size).to eq(1)
    end
end
