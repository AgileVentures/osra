require 'rails_helper'

describe Partner, type: :model do

  it 'should have a valid factory' do
    expect(build_stubbed :partner).to be_valid
  end

  it { is_expected.to validate_presence_of :name }

  describe 'name uniqueness validation' do
    before { create :partner }
    it { is_expected.to validate_uniqueness_of :name }
  end

  it { is_expected.to validate_presence_of :province }
  it { is_expected.to belong_to :province }
  it { is_expected.to belong_to :status }

  it { is_expected.to allow_value(Date.current, Date.yesterday).for :start_date }
  it { is_expected.not_to allow_value(Date.tomorrow).for :start_date }
  [7, 'yes', true].each do |bad_date_value|
    it { is_expected.to_not allow_value(bad_date_value).for :start_date }
  end

  it { is_expected.to have_many :orphan_lists }
  it { is_expected.to have_many(:orphans).through :orphan_lists }

  describe 'callbacks' do
    describe 'after_initialize #set_defaults' do
      describe 'status' do
        let!(:active_status) { create :status, name: 'Active' }
        let(:on_hold_status) { build_stubbed :status, name: 'On Hold' }

        it 'defaults status to "Active"' do
          expect(Partner.new.status).to eq active_status
        end

        it 'sets non-default status if provided' do
          options = { status: on_hold_status }
          expect(Partner.new(options).status).to eq on_hold_status
        end
      end

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

    describe 'before_create #generate_osra_num' do
      let(:new_partner) { build :partner }

      it 'sets osra_num' do
        new_partner.save!
        expect(new_partner.osra_num).not_to be_nil
      end

      it 'sets the first 2 digits of osra_num to province code' do
        new_partner.save!
        expect(new_partner.osra_num[0..1]).to eq new_partner.province.code.to_s
      end

      it 'sets the last 3 digits of osra_num to sequential_id' do
        new_partner.sequential_id = 999
        new_partner.save!
        expect(new_partner.osra_num[2..-1]).to eq '999'
      end
    end
  end
end
