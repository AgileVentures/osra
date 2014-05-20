require 'spec_helper'

describe Province do
  it "should not be valid without a name" do
    Province.new(:code => 11).should_not be_valid
  end

  it "should reject a province with an invalid code" do
    Province.new(:name => "Damascus", :code => 99).should_not be_valid
  end

  it "should accept provinces with names and valid codes" do
    [11,12,13,14,15,16,17,18,19,29].each do |c|
      Province.new(:name => "Damascus", :code => c).should be_valid
    end
  end

  it "name should be unique" do
    Province.create(:name => "Damascus", :code => 11)
    Province.create(:name => "Damascus", :code => 12).should_not be_valid
  end

  it "code should be unique" do
    Province.create(:name => "Damascus", :code => 11)
    Province.create(:name => "Aleppo", :code => 11).should_not be_valid
  end

end
