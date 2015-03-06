require 'rails_helper'
require 'update_sponsor_sponsorship_data'

describe UpdateSponsorSponsorshipData do
  let(:sponsor) { FactoryGirl.create :sponsor, requested_orphan_count: 1 }
  let!(:sponsorship) { FactoryGirl.create :sponsorship, sponsor: sponsor }
  let(:service) { UpdateSponsorSponsorshipData.new(sponsor) }

  describe '#call' do

    context 'when sponsorship is created' do
      it 'sets request_fulfilled' do
        expect{ service.call }.to change(sponsor, :request_fulfilled).
          from(false).to(true)
      end

      it 'sets active_sponsorship_count' do
        expect{ service.call }.to change(sponsor, :active_sponsorship_count).
          from(0).to(1)
      end
    end

    context 'when sponsorship is inactivated' do
      before do
        service.call
        sponsorship.update(active: false, end_date: Date.current)
      end

      it 'sets request_fulfilled' do
        expect{ service.call }.to change(sponsor, :request_fulfilled).
          from(true).to(false)
      end

      it 'sets active_sponsorship_count' do
        expect{ service.call }.to change(sponsor, :active_sponsorship_count).
          from(1).to(0)
      end
    end
  end
end
