require 'rails_helper'

describe Sponsorship, type: :model do

  it 'should have a valid factory' do
    expect(build_stubbed :sponsorship).to be_valid
  end

  it { is_expected.to validate_presence_of :sponsor }
  it { is_expected.to validate_presence_of :orphan }
  it { is_expected.to validate_presence_of :sponsorship_status }
  it { is_expected.to belong_to :sponsor }
  it { is_expected.to belong_to :orphan }
  it { is_expected.to belong_to :sponsorship_status }

  describe 'callbacks' do
    describe 'after_initialize #set_defaults' do
      describe 'start_date' do
        it 'defaults start_date to current date' do
          expect(Partner.new.start_date).to eq Date.current
        end

        it 'sets non-default start_date if provided' do
          options = { start_date: Date.yesterday }
          expect(Partner.new(options).start_date).to eq Date.yesterday
        end
      end
    end
  end
end
