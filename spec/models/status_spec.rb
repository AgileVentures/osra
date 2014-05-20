require 'spec_helper'

describe Status do
  it "should not be valid without a name" do
    Status.new(:code => 1).should_not be_valid
  end

  it "should not be valid without a code" do
    Status.new(:name => "Status").should_not be_valid
  end

  it "should have a valid name and code" do
    Status.new(:name => "Status", :code => 1).should be_valid
  end

  it "name should be unique" do
    Status.create(:name => "Status", :code => 1)
    Status.new(:name => "Status", :code => 2).should_not be_valid
  end

  it "code should be unique" do
    Status.create(:name => "Status", :code => 1)
    Status.new(:name => "Status 2", :code => 1).should_not be_valid
  end
end