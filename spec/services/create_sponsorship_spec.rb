require 'rails_helper'
require 'create_sponsorship'

describe CreateSponsorship do
  let(:sponsor) { FactoryGirl.create :sponsor, requested_orphan_count: 1 }
  let(:orphan) { FactoryGirl.create :orphan }
  let(:sponsorship) { FactoryGirl.build :sponsorship, sponsor: sponsor,
                      orphan: orphan }
  let(:service) { CreateSponsorship.new(sponsorship) }

  describe '#call' do

    context 'when successful' do
      it 'creates a sponsorship' do
        expect{ service.call }.to change(Sponsorship, :count).by(1)
      end

      it 'updates sponsor request_fulfilled' do
        expect{ service.call }.to change(sponsor, :request_fulfilled).
          from(false).to(true)
      end

      it 'updates sponsor active_sponsorship_count' do
        expect{ service.call }.to change(sponsor, :active_sponsorship_count).
          from(0).to(1)
      end

      it 'updates orphan sponsorship status' do
        sponsored_status = OrphanSponsorshipStatus.find_by_name 'Sponsored'

        expect{ service.call }.to change(orphan, :orphan_sponsorship_status).
          to(sponsored_status)
      end

      it 'returns true' do
        expect(service.call).to eq true
      end
    end

    context 'when unsuccessful' do
      before do
        allow(service).to receive(:persist_sponsorship!).and_raise 'BOOM'
      end

      it 'does not create a sponsorship' do
        expect{ service.call }.not_to change(Sponsorship, :count)
      end

      it 'does not update sponsor request_fulfilled' do
        expect{ service.call }.not_to change(sponsor, :request_fulfilled)
      end

      it 'does not update sponsor active_sponsorship_count' do
        expect{ service.call }.not_to change(sponsor, :active_sponsorship_count)
      end

      it 'updates orphan sponsorship status' do
        expect{ service.call }.not_to change(orphan, :orphan_sponsorship_status)
      end

      it "sets @error_msg to the rescued error's message" do
        service.call
        expect(service.error_msg).to eq 'BOOM'
      end

      it 'returns false' do
        expect(service.call).to eq false
      end
    end
  end
end
