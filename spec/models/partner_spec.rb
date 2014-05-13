require 'spec_helper'

describe Partner do


  it "should require a name" do
    Partner.create().should_not be_valid
  end

  it "should have a valid name and province" do
    province = Province.create(:code => 11)

    Partner.create(:name => "Partner One", :province => province).should be_valid
  end

  it "should require a province" do
    Partner.create(:name => "Partner One").should_not be_valid
  end

  it "should reject an invalid province" do
    province = Province.create(:code => 99)
    Partner.create(:name => "Partner One", :province => province).should_not be_valid
  end

end
