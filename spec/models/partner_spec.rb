require 'spec_helper'

describe Partner do

  before(:all) do

    @province1 = Province.create(:name => "Hama", :code => 14)
    @province2 = Province.create(:name => "Homs", :code => 13)
    @status = Status.create(name: "Under Revision", code: 4)

  end

  it "should not be valid without a name" do
    Partner.new(:province => @province1).should_not be_valid
  end

  it "should not be valid without a province" do
    Partner.new(:name => "Partner One").should_not be_valid
  end

  it "should have a valid name and province" do
    Partner.new(:name => "Partner One", :province => @province1).should be_valid
  end

  it 'should default status "Under Revision" unless specified' do
    partner = Partner.create(:name => "Partner One", :province => @province1)
    partner.status.should eq Status.find_by_name('Under Revision')
  end

  it 'should set the custom status when specified' do
    status = Status.create(name: "Active", code: 1)
    partner = Partner.create(:name => "Partner One", :province => @province1, :status => status)
    partner.status.should eq status
  end

  it 'partnership start date should default to today date' do
    partner = Partner.create(:name => 'Partner One',:province => @province1 )
    partner.partnership_start_date.should eq Date.today
  end

  it 'partnership start date should be set to a custom date when specified' do
    partner = Partner.create(:name => 'Partner One',:province => @province1, :partnership_start_date => Date.yesterday )
    partner.partnership_start_date.should eq Date.yesterday
  end

  it 'partnership start date should not be in the future' do
    partner = Partner.new(:name => 'Partner One',:province => @province1, :partnership_start_date => Date.tomorrow )
    partner.should_not be_valid
  end

  it 'should have an osra_id' do
    partner = Partner.create(:name => 'Partner One',:province => @province1 )
    partner.osra_num.should_not be_nil
  end

  it 'osra_num should have the first 2 digits as the province code' do
    partner = Partner.create(:name => 'Partner One',:province => @province1 )
    partner.osra_num[0...2].should eq partner.province.code.to_s
  end

  it 'osra_num should have the last 3 digit as 001 for the first partner in a province' do
    partner = Partner.create(:name => 'Partner Two',:province => @province2 )
    partner.osra_num[2..-1].should eq '001'
  end

  after(:all) do
    Province.all.each do |p|
      p.destroy!
    end
  end

end
