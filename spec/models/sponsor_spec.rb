require 'spec_helper'


describe Sponsor do

  before(:each) do
    @status = Status.create(name: "Under Revision", code: 4)
  end

  it "should not be valid without a name" do
    expect(Sponsor.new(country: 'syria')).to be_invalid
  end

  it "should not be valid without a country" do
    expect(Sponsor.new(name: 'sponsor1')).to be_invalid
  end

  it "should have a valid name and country" do
  	expect(Sponsor.new(name: 'sponsor1', country: 'syria')).to be_valid
  end

  it 'should default status "Under Revision" unless specified' do
    sponsor = Sponsor.create(name: 'sponsor1', country: 'syria')
    expect(sponsor.status).to eq Status.find_by_name('Under Revision')
  end

  it 'should set the custom status when specified' do
    status = Status.create(name: "Active", code: 1)
    sponsor = Sponsor.new(name: 'sponsor1', country: 'syria', status: status)
    expect(sponsor.status).to eq status
  end

  it 'sponsorship start date should default to today date' do
    sponsor = Sponsor.create(name: 'sponsor1', country: 'syria')
    expect(sponsor.sponsorship_start_date).to eq Date.today
  end

  it 'sponsorship start date should be set to a custom date when specified' do
    sponsor = Sponsor.create(name: 'sponsor1', country: 'syria', sponsorship_start_date: Date.yesterday)
    expect(sponsor.sponsorship_start_date).to eq Date.yesterday
  end

  it 'sponsorship start date should not be in the future' do
    sponsor = Sponsor.new(name: 'sponsor1', country: 'syria', :sponsorship_start_date => Date.tomorrow)
    expect(sponsor).to be_invalid
  end


end
