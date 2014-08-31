require 'rails_helper'

describe Partner, type: :model do

  before(:each) do
    @province1 = Province.create(:name => "Hama", :code => 14)
    @province2 = Province.create(:name => "Homs", :code => 13)
    @status = Status.create(name: "Under Revision", code: 4)
  end

  it "should not be valid without a name" do
    expect(Partner.new(:province => @province1)).to be_invalid
  end

  it "should not be valid without a province" do
    expect(Partner.new(:name => "Partner One")).to be_invalid
  end

  it "should have a valid name and province" do
    expect(Partner.new(:name => "Partner One", :province => @province1)).to be_valid
  end

  it 'should default status to "Under Revision" unless specified' do
    partner = Partner.create(:name => "Partner One", :province => @province1)
    expect(partner.status).to eq Status.find_by_name('Under Revision')
  end

  it 'should set the custom status when specified' do
    status = Status.create(name: "Active", code: 1)
    partner = Partner.new(:name => "Partner One", :province => @province1, :status => status)
    expect(partner.status).to eq status
  end

  it 'partnership start date should default to today date' do
    partner = Partner.create(:name => 'Partner One',:province => @province1 )
    expect(partner.start_date).to eq Date.current
  end

  it 'partnership start date should be set to a custom date when specified' do
    partner = Partner.new(:name => 'Partner One',:province => @province1, :start_date => Date.yesterday )
    expect(partner.start_date).to eq Date.yesterday
  end

  it 'partnership start date should not be in the future' do
    partner = Partner.new(:name => 'Partner One',:province => @province1, :start_date => Date.tomorrow )
    expect(partner).to be_invalid
  end

  it 'should have an osra_id' do
    partner = Partner.create(:name => 'Partner One', :province => @province1)
    expect(partner.osra_num).to be
  end

  it 'osra_num should have the first 2 digits as the province code' do
    partner = Partner.create(:name => 'Partner One', :province => @province1)
    expect(partner.osra_num[0...2]).to eq partner.province.code.to_s
  end

  it 'osra_num should have the last 3 digit as 001 for the first partner in a province' do
    partner = Partner.create(:name => 'Partner Two', :province => @province2)
    expect(partner.osra_num[2..-1]).to eq '001'
  end

end
