require 'rails_helper'

describe Sponsor, type: :model do

  before(:each) do
    Status.create(name: "Under Revision", code: 4)
    @type = SponsorType.create(name: 'Individual', code: 1)
  end

  it "should not be valid without a name" do
    expect(Sponsor.new(country: 'syria', sponsor_type: @type)).to be_invalid
  end

  it "should not be valid without a country" do
    expect(Sponsor.new(name: 'sponsor1', sponsor_type: @type)).to be_invalid
  end

  it "should not be valid without a type" do
    expect(Sponsor.new(name: 'sponsor1', country: 'syria')).to be_invalid
  end

  it "should have a valid name, country and type" do
    expect(Sponsor.new(name: 'sponsor1', country: 'syria', sponsor_type: @type, gender: 'Male')).to be_valid
  end

  it 'should set default status "Under Revision" unless specified' do
    sponsor = Sponsor.create(name: 'sponsor1', country: 'syria', sponsor_type: @type, gender: 'Male')
    expect(sponsor.status).to eq Status.find_by_name('Under Revision')
  end

  it 'should set the custom status when specified' do
    status = Status.create(name: "Active", code: 1)
    sponsor = Sponsor.new(name: 'sponsor1', country: 'syria', status: status, sponsor_type: @type)
    expect(sponsor.status).to eq status
  end

  it 'sponsorship start date should default to today date' do
    sponsor = Sponsor.create(name: 'sponsor1', country: 'syria', sponsor_type: @type, gender: 'Male')
    expect(sponsor.sponsorship_start_date).to eq Date.current
  end

  it 'sponsorship start date should be set to a custom date when specified' do
    sponsor = Sponsor.create(name: 'sponsor1', country: 'syria', sponsor_type: @type, sponsorship_start_date: Date.yesterday)
    expect(sponsor.sponsorship_start_date).to eq Date.yesterday
  end

  it 'sponsorship start date should not be in the future' do
    sponsor = Sponsor.new(name: 'sponsor1', country: 'syria', :sponsorship_start_date => Date.tomorrow)
    expect(sponsor).to be_invalid
  end

end
