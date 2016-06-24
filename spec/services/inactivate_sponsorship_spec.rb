require 'rails_helper'
require 'inactivate_sponsorship'

describe InactivateSponsorship do
  let(:sponsor) { FactoryGirl.create :sponsor, requested_orphan_count: 1 }
  let(:orphan) { FactoryGirl.create :orphan }
  let(:sponsorship) { FactoryGirl.build :sponsorship, sponsor: sponsor,
                      orphan: orphan }
  let(:service) { InactivateSponsorship.new(sponsorship: sponsorship,
                                            end_date: Date.current) }

  before(:each) do
    CreateSponsorship.new(sponsorship).call
  end

  describe '#call' do

    context 'when successful' do
      it 'inactivates sponsorship' do
        expect{ service.call }.to change(sponsorship, :active).
          from(true).to(false)
      end

      it 'sets sponsorship end_date' do
        expect{ service.call }.to change(sponsorship, :end_date).
          from(nil).to(Date.current)
      end

      it 'updates sponsor request_fulfilled' do
        expect{ service.call }.to change(sponsor, :request_fulfilled).
          from(true).to(false)
      end

      it 'updates sponsor active_sponsorship_count' do
        expect{ service.call }.to change(sponsor, :active_sponsorship_count).
          from(1).to(0)
      end

      it 'updates orphan sponsorship_status' do
        expect{ service.call }.to change(orphan, :sponsorship_status).
          to('previously_sponsored')
      end

      it 'returns true' do
        expect(service.call).to eq true
      end
    end

    context 'when unsuccessful' do

      before do
        allow(service).to receive(:inactivate_sponsorship!).and_raise 'BOOM'
      end

      it 'does not inactivate sponsorship' do
        expect{ service.call }.not_to change(sponsorship, :active)
      end

      it 'does not set sponsorship end_date' do
        expect{ service.call }.not_to change(sponsorship, :end_date)
      end

      it 'does not update sponsor request_fulfilled' do
        expect{ service.call }.not_to change(sponsor, :request_fulfilled)
      end

      it 'does not update sponsor active_sponsorship_count' do
        expect{ service.call }.not_to change(sponsor, :active_sponsorship_count)
      end

      it 'does not update orphan sponsorship_status' do
        expect{ service.call }.not_to change(orphan, :sponsorship_status)
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
