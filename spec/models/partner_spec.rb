require 'spec_helper'

describe Partner do

  it "should have a name" do
    Partner.create(:name => "Partner One").should be_valid
  end

  it "should require a name" do
    Partner.create().should_not be_valid
  end

end
