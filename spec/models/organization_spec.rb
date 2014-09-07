require 'rails_helper'

RSpec.describe Organization, :type => :model do

  let(:status) {FactoryGirl.build_stubbed(:status)}
  let(:params) { {code: 11, name: 'Org1', country: 'UK', region: 'Europe', status: status, start_date: '03/03/14' } }

  context 'returns errors when invalid information passed' do
    it 'is invalid if no org name is specified' do
      expect(Organization.new(params.merge(name: ''))).to be_invalid
    end

    it 'is invalid if no status' do
      expect(Organization.new(params.merge(status: nil))).to be_invalid
    end

    it 'is invalid if no country' do
      expect(Organization.new(params.merge(country: ''))).to be_invalid
    end

    it 'is invalid if no organization code' do
      expect(Organization.new(params.merge(code: ''))).to be_invalid
    end

    it 'is invalid if single digit integer is passed' do
      expect(Organization.new(params.merge(code: 1))).to be_invalid
    end

    it 'should not allow start_date to be in the future' do
      org = Organization.new(params.merge(start_date: Date.tomorrow))
      expect(org).to be_invalid
    end
  end

  context 'sets appropriate values for organization fields' do
    it 'defaults to status "Under Revision" unless specified' do
      org = Organization.create((params.merge(status: nil)))
      expect(org.status).to eq Status.find_by_name('Under Revision')
    end

    it 'sets the custom status when specified' do
      org = Organization.new(params.merge(status: status))
      expect(org.status).to eq status
    end

    it 'sets region when specified' do
      org = Organization.new(params.merge(region: 'Europe'))
      expect(org.region).to eq 'Europe'
    end

    it 'defaults to current date if such not set' do
      org = Organization.new(params.merge(start_date: ''))
      expect(org.start_date).to eq Date.current
    end

    it 'sets the date to yesterday when such date is passed' do
      org = Organization.new(params.merge(start_date: Date.yesterday))
      expect(org.start_date).to eq Date.yesterday
    end

    it 'has code number according to specified' do
      org = Organization.new(params.merge(code: 11))
      expect(org.code).to eq 11
    end
  end
end
