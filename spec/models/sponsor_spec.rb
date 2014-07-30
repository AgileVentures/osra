require 'spec_helper'

describe Sponsor do
  it "should not be valid without a name" do
    expect(Sponsor.new(country: 'syria')).to be_invalid
  end

  it "should not be valid without a country" do
    expect(Sponsor.new(name: 'sponsor1')).to be_invalid
  end

  it "should have a valid name and country" do
  	expect(Sponsor.new(name: 'sponsor1', country: 'syria')).to be_valid
  end
end
