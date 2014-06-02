require 'spec_helper'

describe Partner do

  before(:all) do

    @province = Province.create(:name => "Damascus", :code => 11)
    @status = Status.create(name: "Under Revision", code: 4)

  end


  it "should not be valid without a name" do
    Partner.new(:province => @province).should_not be_valid
  end

  it "should not be valid without a province" do
    Partner.new(:name => "Partner One").should_not be_valid
  end

  it "should have a valid name and province" do
    Partner.new(:name => "Partner One", :province => @province).should be_valid
  end

  it 'should default status "Under Revision" unless specified' do
    partner = Partner.create(:name => "Partner One", :province => @province)
    partner.status.should eq Status.find_by_name('Under Revision')
  end

  it 'should set the custom status when specified' do
    status = Status.create(name: "Active", code: 1)
    partner = Partner.create(:name => "Partner One", :province => @province, :status => status)
    partner.status.should eq status
  end

  it 'partnership start date should default to today date' do
    partner = Partner.create(:name => 'Partner One',:province => @province )
    partner.partnership_start_date.should eq Date.today
  end

  it 'partnership start date should be set to a custom date when specified' do
    partner = Partner.create(:name => 'Partner One',:province => @province, :partnership_start_date => Date.yesterday )
    partner.partnership_start_date.should eq Date.yesterday
  end

  it 'partnership start date should not be in the future' do
    partner = Partner.new(:name => 'Partner One',:province => @province, :partnership_start_date => Date.tomorrow )
    partner.should_not be_valid
  end

end
