require 'rails_helper'
require 'resolve_orphan_sponsorship_status'

describe ResolveOrphanSponsorshipStatus do
  let(:orphan) { FactoryGirl.create :orphan }
  let(:service) { ResolveOrphanSponsorshipStatus.new(orphan) }

  context 'when unsponsored' do
    it 'returns Unsponsored status' do
      expect(service.call).to eq 'Unsponsored'
    end
  end

  describe 'with sponsorships' do
    let(:sponsorship) { FactoryGirl.build :sponsorship, orphan: orphan }
    before do
      CreateSponsorship.new(sponsorship).call
    end

    context 'when currently sponsored' do
      it 'returns Sponsored status' do
        expect(service.call).to eq 'Sponsored'
      end
    end

    context 'when previously sponsored' do
      before do
        InactivateSponsorship.new(sponsorship: sponsorship, end_date: Date.current).call
      end

      it 'returns Previously Sponsored status' do
        expect(service.call).to eq 'Previously Sponsored'
      end
    end
  end
end
