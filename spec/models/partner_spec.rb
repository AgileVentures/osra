require 'spec_helper'

describe Partner do
  it "should not be valid without a name" do
    province = Province.create(:code => 11)
    Partner.new(:province => province).should_not be_valid
  end

  it "should not be valid without a province" do
    Partner.new(:name => "Partner One").should_not be_valid
  end

  it "should have a valid name and province" do
    province = Province.create(:name => "Damascus", :code => 11)
    Partner.new(:name => "Partner One", :province => province).should be_valid
  end
end
