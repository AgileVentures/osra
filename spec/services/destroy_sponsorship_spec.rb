require 'rails_helper'
require 'destroy_sponsorship'

describe DestroySponsorship do
  let(:sponsor) { FactoryGirl.create :sponsor, requested_orphan_count: 1 }
  let(:orphan) { FactoryGirl.create :orphan }
  let(:sponsorship) { FactoryGirl.build :sponsorship, sponsor: sponsor,
                      orphan: orphan }
  let(:service) { DestroySponsorship.new(sponsorship) }

  before { CreateSponsorship.new(sponsorship).call }

  describe '#call' do

    context 'when successful' do
      it 'destroys the sponsorship' do
        expect{ service.call }.to change(Sponsorship, :count).by(-1)
      end

      it 'updates sponsor request_fulfilled' do
        expect{ service.call }.to change(sponsor, :request_fulfilled).
          from(true).to(false)
      end

      it 'updates sponsor active_sponsorship_count' do
        expect{ service.call }.to change(sponsor, :active_sponsorship_count).
          from(1).to(0)
      end

      it 'updates orphan sponsorship status' do
        sponsored_status = OrphanSponsorshipStatus.find_by_name 'Sponsored'
        unsponsored_status = OrphanSponsorshipStatus.find_by_name 'Unsponsored'

        expect{ service.call }.to change(orphan, :orphan_sponsorship_status).
          from(sponsored_status).to(unsponsored_status)
      end

      it 'return true' do
        expect(service.call).to eq true
      end
    end

    context 'when unsuccessful' do

      before do
        allow(service).to receive(:destroy_sponsorship!).and_raise 'BOOM'
      end

      it 'does not destroy the sponsorship' do
        expect{ service.call }.not_to change(Sponsorship, :count)
      end

      it 'does not update sponsor request_fulfilled' do
        expect{ service.call }.not_to change(sponsor, :request_fulfilled)
      end

      it 'does not update sponsor active_sponsorship_count' do
        expect{ service.call }.not_to change(sponsor, :active_sponsorship_count)
      end

      it 'does not update orphan sponsorship status' do
        expect{ service.call }.not_to change(orphan, :orphan_sponsorship_status)
      end

      it 'sets @error_msg' do
        service.call
        expect(service.error_msg).to eq 'BOOM'
      end

      it 'returns false' do
        expect(service.call).to eq false
      end
    end
  end
end
