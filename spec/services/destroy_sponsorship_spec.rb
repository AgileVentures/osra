require 'rails_helper'
require 'destroy_sponsorship'

describe DestroySponsorship do
  let(:sponsor) { FactoryGirl.create :sponsor, requested_orphan_count: 1 }
  let(:orphan) { FactoryGirl.create :orphan }

  before(:each) do
    sponsorship = FactoryGirl.build :sponsorship, sponsor: sponsor,
      orphan: orphan
    CreateSponsorship.new(sponsorship).call
    @service = DestroySponsorship.new(sponsorship)
  end

  describe '#call' do
    it 'destroys the sponsorship' do
      expect{ @service.call }.to change(Sponsorship, :count).by(-1)
    end

    it 'updates sponsor request_fulfilled' do
      expect{ @service.call }.to change(sponsor, :request_fulfilled).
        from(true).to(false)
    end

    it 'updates sponsor active_sponsorship_count' do
      expect{ @service.call }.to change(sponsor, :active_sponsorship_count).
        from(1).to(0)
    end

    it 'updates orphan sponsorship status' do
      sponsored_status = OrphanSponsorshipStatus.find_by_name 'Sponsored'
      unsponsored_status = OrphanSponsorshipStatus.find_by_name 'Unsponsored'

      expect{ @service.call }.to change(orphan, :orphan_sponsorship_status).
        from(sponsored_status).to(unsponsored_status)
    end
  end
end
