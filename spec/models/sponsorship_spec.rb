require 'rails_helper'

describe Sponsorship, type: :model do

  it 'should have a valid factory' do
    expect(build_stubbed :sponsorship).to be_valid
  end

  it { is_expected.to validate_presence_of :sponsor }
  it { is_expected.to validate_presence_of :orphan }
  it { is_expected.to belong_to :sponsor }
  it { is_expected.to belong_to :orphan }
  it { is_expected.to have_one :cashbox }

  describe 'validations' do
    let(:inactive_status) { Status.find_by_name 'Inactive' }
    let(:ineligible_sponsor) { build_stubbed :sponsor, status: inactive_status }
    let(:request_fulfilled_sponsor) { build_stubbed :sponsor, request_fulfilled: true}
    let(:ineligible_orphan) { build_stubbed :orphan, status: 'inactive' }

    it 'disallows creation of new sponsorships with ineligible sponsors' do
      expect{ create :sponsorship, sponsor: ineligible_sponsor }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'disallows creation of new sponsorships for sponsors with fulfilled requests' do
      expect{ create :sponsorship, sponsor: request_fulfilled_sponsor }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'disallows creation of new sponsorships with ineligible orphans' do
      expect{ create :sponsorship, orphan: ineligible_orphan }.to raise_error ActiveRecord::RecordInvalid
    end

    describe 'disallows creation of new sponsorships with a start date prior to OSRA establishment date' do
      it { is_expected.to have_validation :date_beyond_osra_establishment, :on => :start_date }
    end

    describe 'start_date' do
      it { is_expected.to have_validation :valid_date_presence, :on => :start_date }
      it { is_expected.to have_validation :date_beyond_osra_establishment, :on => :start_date }
      it { is_expected.to have_validation :date_not_beyond_first_of_next_month, :on => :start_date }
    end

    describe 'end_date' do
      subject(:sponsorship) { build_stubbed :sponsorship }

      before(:each) do
        sponsorship.active = false
      end

      let(:start_date) { sponsorship.start_date }

      it { is_expected.to have_validation :valid_date_presence, :on => :end_date,
                                                                :options => {if: '!active'}}

      it { is_expected.to allow_value(start_date + 1).for :end_date }
      it { is_expected.to_not allow_value(start_date - 1).for :end_date }
      it { is_expected.to allow_value(start_date).for :end_date }
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
        InactivateSponsorship.new(sponsorship: active_sponsorship,
                                  end_date: future_date).call
        new_sponsorship = create :sponsorship, sponsor: sponsor, orphan: orphan
        expect do
          InactivateSponsorship.new(sponsorship: new_sponsorship,
                                          end_date: future_date).call
        end.not_to raise_error
      end
    end
  end

  describe 'callbacks' do
    describe 'before_validation on: :create' do

      it 'sets the .active attribute to true' do
        sponsorship = Sponsorship.new
        sponsorship.valid?

        expect(sponsorship.active).to eq true
      end
    end
  end

  describe 'scopes' do
    let!(:active_sponsorship) { create :sponsorship }
    let(:inactive_sponsorship) { create :sponsorship }

    before(:each) do
      future_date = active_sponsorship.start_date + 1.month
      InactivateSponsorship.new(sponsorship: inactive_sponsorship,
                                end_date: future_date).call
    end

    it '.all_active should return active sponsorships' do
      expect(Sponsorship.all_active.to_a).to eq [active_sponsorship]
    end

    it '.all_inactive should return inactive sponsorships' do
      expect(Sponsorship.all_inactive.to_a).to eq [inactive_sponsorship]
    end
  end
end
