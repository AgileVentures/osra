require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe Sponsorship, type: :model do

  it 'should have a valid factory' do
    expect(build_stubbed :sponsorship).to be_valid
  end

  it { is_expected.to validate_presence_of :sponsor }
  it { is_expected.to validate_presence_of :orphan }
  it { is_expected.to belong_to :sponsor }
  it { is_expected.to belong_to :orphan }

  describe 'validations' do
    let(:inactive_status) { Status.find_by_name 'Inactive' }
    let(:ineligible_sponsor) { build_stubbed :sponsor, status: inactive_status }
    let(:request_fulfilled_sponsor) { build_stubbed :sponsor, request_fulfilled: true}
    let(:inactive_orphan_status) { OrphanStatus.find_by_name('Inactive') }
    let(:ineligible_orphan) { build_stubbed :orphan, orphan_status: inactive_orphan_status}

    it 'disallows creation of new sponsorships with ineligible sponsors' do
      expect{ create :sponsorship, sponsor: ineligible_sponsor }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'disallows creation of new sponsorships for sponsors with fulfilled requests' do
      expect{ create :sponsorship, sponsor: request_fulfilled_sponsor }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'disallows creation of new sponsorships with ineligible orphans' do
      expect{ create :sponsorship, orphan: ineligible_orphan }.to raise_error ActiveRecord::RecordInvalid
    end

    describe 'start_date' do
      before(:all) { travel_to Date.parse "15-12-2011" }
      after(:all) { travel_back }
      
      let (:today) { Date.current }
      let (:yesterday) { today.yesterday }
      let (:first_of_next_month) { today.beginning_of_month.next_month }
      let (:last_day_of_the_month) { first_of_next_month - 1.day }
      let (:second_of_next_month) { first_of_next_month + 1.day }
      let (:two_months_ahead) { today + 2.months }

      it { is_expected.to_not allow_value("").for :start_date }
      it { is_expected.to_not allow_value("42").for :start_date }
      it { is_expected.to_not allow_value("5-12").for :start_date }
      it { is_expected.to_not allow_value(second_of_next_month).for :start_date }
      it { is_expected.to_not allow_value(two_months_ahead).for :start_date }

      it { is_expected.to allow_value(today).for :start_date }
      it { is_expected.to allow_value(first_of_next_month).for :start_date }
      it { is_expected.to allow_value(yesterday).for :start_date }
      it { is_expected.to allow_value(last_day_of_the_month).for :start_date }
    end
    
    describe 'end_date' do
      subject(:sponsorship) { build_stubbed :sponsorship }

      before(:each) do
        sponsorship.active = false
      end 

      let(:start_date) { sponsorship.start_date }
 
      it { is_expected.to allow_value(start_date + 1).for :end_date }
      it { is_expected.to_not allow_value(start_date - 1).for :end_date }
      it { is_expected.to allow_value(start_date).for :end_date }
 
      ["", "42", "5-12"].each do |bad_date|
        it { is_expected.to_not allow_value(bad_date).for :end_date }
      end 
    end 

    describe 'disallow concurrent active sponsorships' do
      let(:orphan) { create :orphan }
      let(:sponsor) { create :sponsor }
      let!(:active_sponsorship) { create :sponsorship, sponsor: sponsor, orphan: orphan }

      it 'disallows concurrent active sponsorships' do
        expect{ create :sponsorship, sponsor: sponsor, orphan: orphan }.to raise_error ActiveRecord::RecordInvalid
      end

      it 'does not disallow multiple inactive sponsorships' do
        future_date = active_sponsorship.start_date + 1.month
        active_sponsorship.inactivate future_date
        new_sponsorship = create :sponsorship, sponsor: sponsor, orphan: orphan
        expect{ new_sponsorship.inactivate future_date }.not_to raise_error
      end
    end
  end

  describe 'callbacks' do
    describe 'before_create & after_save' do
      let(:sponsorship) { build :sponsorship }
      before(:each) do
        allow(sponsorship.sponsor).to receive :update_request_fulfilled!
        allow(sponsorship.sponsor).to receive :update_active_sponsorship_count!
        sponsorship.save!
      end

      it 'sets the .active attribute to true' do
        expect(sponsorship.reload.active).to eq true
      end

      it 'sets orphan sponsorship status to Sponsored' do
        expect(sponsorship.orphan.orphan_sponsorship_status.name).to eq 'Sponsored'
      end

      it 'calls Sponsor#set_request_fulfilled' do
        expect(sponsorship.sponsor).to have_received(:update_request_fulfilled!)
      end

      it 'calls Sponsor#update_active_sponsorship_count' do
        expect(sponsorship.sponsor).to have_received(:update_active_sponsorship_count!)
      end
    end
  end

  describe 'methods' do
    context '#inactivate' do
      let(:sponsorship) { create :sponsorship }
      
      it 'sets attributes for the sponsorship and it\'s orphan' do
        future_date = sponsorship.start_date + 1.month
        sponsorship.inactivate future_date
        expect(sponsorship.reload.active).to eq false
        expect(sponsorship.end_date).to eq future_date
        expect(sponsorship.orphan.reload.orphan_sponsorship_status.name).to eq 'Previously Sponsored'
      end

      it 'returns false if end_date precedes the start_date' do
        end_date = sponsorship.start_date - 1.month
        expect(sponsorship.inactivate end_date).to eq false
      end
    end

    context '#set_active_to_true' do
      it 'sets .active to true' do
        sponsorship = Sponsorship.new(active: false)
        sponsorship.send(:set_active_to_true)
        expect(sponsorship.active).to eq true
      end
    end
  end

  describe 'scopes' do
    let!(:active_sponsorship) { create :sponsorship }
    let(:inactive_sponsorship) { create :sponsorship }
    before(:each) do
      future_date = active_sponsorship.start_date + 1.month
      inactive_sponsorship.inactivate future_date
    end

    it '.all_active should return active sponsorships' do
      expect(Sponsorship.all_active.to_a).to eq [active_sponsorship]
    end

    it '.all_inactive should return inactive sponsorships' do
      expect(Sponsorship.all_inactive.to_a).to eq [inactive_sponsorship]
    end
  end
end
