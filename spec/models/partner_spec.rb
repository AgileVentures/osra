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

  it 'should default status "Under Revision" unless specified' do
    status = Status.create(name: "Under Revision", code: 4)
    province = Province.create(:name => "Damascus", :code => 11)
    partner = Partner.create(:name => "Partner One", :province => province)
    partner.status.should eq status
  end

  it 'should set the custom status when specified' do
    status = Status.create(name: "Active", code: 1)
    province = Province.create(:name => "Damascus", :code => 11)
    partner = Partner.create(:name => "Partner One", :province => province, :status => status)
    partner.status.should eq status
  end
end
