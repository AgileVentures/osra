require 'rails_helper'

describe Sponsorship, type: :model do

  before(:each) do
    create :orphan_status, name: 'Active'
    create :orphan_sponsorship_status, name: 'Sponsored'
    create :orphan_sponsorship_status, name: 'Unsponsored'
    create :orphan_sponsorship_status, name: 'Previously Sponsored'
    create :orphan_sponsorship_status, name: 'On Hold'
    create :status, name: 'Active'
  end

  it 'should have a valid factory' do
    expect(build_stubbed :sponsorship).to be_valid
  end

  it { is_expected.to validate_presence_of :sponsor }
  it { is_expected.to validate_presence_of :orphan }
  it { is_expected.to belong_to :sponsor }
  it { is_expected.to belong_to :orphan }

  describe 'validations' do
    let(:inactive_status) do
      Status.find_by_name('Inactive') || create(:status, name: 'Inactive')
    end
    let(:ineligible_sponsor) { build_stubbed :sponsor, status: inactive_status }
    let(:request_fulfilled_sponsor) { build_stubbed :sponsor, request_fulfilled: true}
    let(:inactive_orphan_status) do
      OrphanStatus.find_by_name('Inactive') || create(:orphan_status, name: 'Inactive')
    end
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

    describe 'disallow concurrent active sponsorships' do
      let(:orphan) { create :orphan }
      let(:sponsor) { create :sponsor }
      let!(:active_sponsorship) { create :sponsorship, sponsor: sponsor, orphan: orphan }

      it 'disallows concurrent active sponsorships' do
        expect{ create :sponsorship, sponsor: sponsor, orphan: orphan }.to raise_error ActiveRecord::RecordInvalid
      end

      it 'does not disallow multiple inactive sponsorships' do
        active_sponsorship.inactivate
        new_sponsorship = create :sponsorship, sponsor: sponsor, orphan: orphan
        expect{ new_sponsorship.inactivate }.not_to raise_error
      end
    end
  end

  describe 'callbacks' do
    describe 'after_initialize #set_defaults' do
      describe 'start_date' do
        it 'defaults start_date to current date' do
          expect(Sponsorship.new.start_date).to eq Date.current
        end

        it 'sets non-default start_date if provided' do
          options = { start_date: Date.yesterday }
          expect(Sponsorship.new(options).start_date).to eq Date.yesterday
        end
      end
    end

    describe 'before_create #set_active_true' do
      let(:sponsorship) { build :sponsorship }
      it 'sets the .active attribute to true' do
        sponsorship.save!
        expect(sponsorship.reload.active).to eq true
        expect(sponsorship.orphan.orphan_sponsorship_status.name).to eq 'Sponsored'
      end
    end
  end

  describe 'methods' do
    it '#inactivate should set active = false & orphan.orphan_sponsorship_status = Previously Sponsored' do
      sponsorship = create :sponsorship
      sponsorship.inactivate
      expect(sponsorship.reload.active).to eq false
      expect(sponsorship.orphan.reload.orphan_sponsorship_status.name).to eq 'Previously Sponsored'
    end

    specify '#set_active_to_true should set .active = true' do
      sponsorship = Sponsorship.new(active: false)
      sponsorship.send(:set_active_to_true)
      expect(sponsorship.active).to eq true
    end
  end

  describe 'scopes' do
    let!(:active_sponsorship) { create :sponsorship }
    let(:inactive_sponsorship) { create :sponsorship }
    before(:each) { inactive_sponsorship.inactivate }

    it '.all_active should return active sponsorships' do
      expect(Sponsorship.all_active.to_a).to eq [active_sponsorship]
    end

    it '.all_inactive should return inactive sponsorships' do
      expect(Sponsorship.all_inactive.to_a).to eq [inactive_sponsorship]
    end
  end
end
