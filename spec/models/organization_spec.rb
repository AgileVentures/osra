require 'rails_helper'

describe Organization, :type => :model do

  let(:status) {FactoryGirl.build_stubbed(:status)}
  let(:params) { {code: 11, name: 'Org1', country: 'UK', region: 'Europe', status: status, start_date: '03/03/14' } }

  it 'has a valid factory' do
    expect(build_stubbed :organization).to be_valid
  end

  context 'makes the right validations' do

    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_uniqueness_of :code }
    it { is_expected.to validate_numericality_of :code }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of :name }

    it { is_expected.to validate_presence_of :country }
    it { is_expected.to validate_presence_of :status_id  }
    it { is_expected.to belong_to :status }

    it { is_expected.to allow_value(Date.current, Date.yesterday).for :start_date }
    it { is_expected.not_to allow_value(Date.tomorrow).for :start_date }
    [7, 'yes', false].each do |bad_date_value|
      it { is_expected.not_to allow_value(bad_date_value).for :start_date }
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

    it 'has code number according to specified' do
      org = Organization.new(params)
      expect(org.code).to eq 11
    end
  end
end
