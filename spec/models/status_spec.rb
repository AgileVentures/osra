require 'rails_helper'

describe Status, type: :model do

  it "should not be valid without a name" do
    expect(Status.new(:code => 1)).to be_invalid
  end

  it "should not be valid without a code" do
    expect(Status.new(:name => "Status")).to be_invalid
  end

  it "should have a valid name and code" do
    expect(Status.new(:name => "Status", :code => 1)).to be_valid
  end

  it "name should be unique" do
    Status.create(:name => "Status", :code => 1)
    expect(Status.new(:name => "Status", :code => 2)).to be_invalid
  end

  it "code should be unique" do
    Status.create(:name => "Status", :code => 1)
    expect(Status.new(:name => "Status 2", :code => 1)).to be_invalid
  end
end