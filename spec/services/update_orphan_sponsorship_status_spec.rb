require 'rails_helper'
require 'update_orphan_sponsorship_status'

describe UpdateOrphanSponsorshipStatus do
  let(:orphan) { FactoryGirl.create :orphan }

  it 'updates orphan sponsorship status' do
    sponsored_status = OrphanSponsorshipStatus.find_by_name 'Sponsored'
    service = UpdateOrphanSponsorshipStatus.new(orphan, 'Sponsored')

    expect{ service.call }.to change(orphan, :orphan_sponsorship_status).
      to(sponsored_status)
  end
end
