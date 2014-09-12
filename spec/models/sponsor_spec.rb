require 'rails_helper'

describe Sponsor, type: :model do

  it 'should have a valid factory' do
    expect(build_stubbed :sponsor).to be_valid
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :country }
  it { is_expected.to validate_presence_of :sponsor_type }

  it { is_expected.to ensure_inclusion_of(:gender).in_array %w(Male Female) }

  it { is_expected.to allow_value(Date.current, Date.yesterday).for :start_date }
  it { is_expected.not_to allow_value(Date.tomorrow).for :start_date }
  [7, 'yes', true].each do |bad_date_value|
    it { is_expected.to_not allow_value(bad_date_value).for :start_date }
  end

  it { is_expected.to belong_to :status }
  it { is_expected.to belong_to :sponsor_type }
  it { is_expected.to have_many(:orphans).through :sponsorships }

  describe 'callbacks' do
    describe 'after_initialize #set_defaults' do
      describe 'status' do
        let!(:under_revision_status) { create :status, name: 'Under Revision' }
        let(:active_status) { build_stubbed :status, name: 'Active' }

        it 'defaults status to "Under Revision"' do
          expect((Sponsor.new).status).to eq under_revision_status
        end

        it 'sets non-default status if provided' do
          options = { status: active_status }
          expect(Sponsor.new(options).status).to eq active_status
        end
      end

      describe 'start_date' do
        it 'defaults start_date to current date' do
          expect(Sponsor.new.start_date).to eq Date.current
        end

        it 'sets non-default start_date if provided' do
          options = { start_date: Date.yesterday }
          expect(Sponsor.new(options).start_date).to eq Date.yesterday
        end
      end
    end

    describe 'before_create #generate_osra_num' do
      # not yet implemented in the model
    end
  end
end
