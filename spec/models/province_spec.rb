require 'spec_helper'

describe Province do

  it "should reject a province with an invalid code" do
    Province.new(:code => 99).should_not be_valid
  end

  it "should accept provices with valid codes" do
    [11,12,13,14,15,16,17,18,19,29].each do |c|
      Province.new(:code => c).should be_valid
    end
  end



end
