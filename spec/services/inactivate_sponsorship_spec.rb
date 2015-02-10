require 'rails_helper'
require 'inactivate_sponsorship'

describe InactivateSponsorship do
  let(:sponsor) { FactoryGirl.create :sponsor, requested_orphan_count: 1 }
  let(:orphan) { FactoryGirl.create :orphan }
  let(:sponsorship) { FactoryGirl.build :sponsorship, sponsor: sponsor,
                      orphan: orphan }

  before(:each) do
    CreateSponsorship.new(sponsorship).call
    @service = InactivateSponsorship.new(sponsorship: sponsorship,
                                         end_date: Date.current)
  end

  describe '#call' do

    it 'inactivates sponsorship' do
      expect{ @service.call }.to change(sponsorship, :active).
        from(true).to(false)
    end

    it 'sets sponsorship end_date' do
      expect{ @service.call }.to change(sponsorship, :end_date).
        from(nil).to(Date.current)
    end

    it 'updates sponsor request_fulfilled' do
      expect{ @service.call }.to change(sponsor, :request_fulfilled).
        from(true).to(false)
    end

    it 'updates sponsor active_sponsorship_count' do
      expect{ @service.call }.to change(sponsor, :active_sponsorship_count).
        from(1).to(0)
    end

    it 'updates orphan_sponsorship_status' do
      previous_status = OrphanSponsorshipStatus.find_by_name 'Previously Sponsored'

      expect{ @service.call }.to change(orphan, :orphan_sponsorship_status).
        to(previous_status)
    end
  end
end
