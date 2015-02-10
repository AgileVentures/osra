require 'rails_helper'
require 'create_sponsorship'

describe CreateSponsorship do
  let(:sponsor) { FactoryGirl.create :sponsor, requested_orphan_count: 1 }
  let(:orphan) { FactoryGirl.create :orphan }

  before(:each) do
    sponsorship = FactoryGirl.build :sponsorship,
      sponsor: sponsor,
      orphan: orphan
    @service = CreateSponsorship.new(sponsorship)
  end

  describe '#call' do
    it 'creates a sponsorship' do
      expect{ @service.call }.to change(Sponsorship, :count).by(1)
    end

    it 'updates sponsor request_fulfilled' do
      expect{ @service.call }.to change(sponsor, :request_fulfilled).
        from(false).to(true)
    end

    it 'updates sponsor active_sponsorship_count' do
      expect{ @service.call }.to change(sponsor, :active_sponsorship_count).
        from(0).to(1)
    end

    it 'updates orphan sponsorship status' do
      sponsored_status = OrphanSponsorshipStatus.find_by_name 'Sponsored'

      expect{ @service.call }.to change(orphan, :orphan_sponsorship_status).
        to(sponsored_status)
    end
  end
end
