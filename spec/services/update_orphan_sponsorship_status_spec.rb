require 'rails_helper'
require 'update_orphan_sponsorship_status'

describe UpdateOrphanSponsorshipStatus do
  let(:orphan) { FactoryGirl.create :orphan }

  it 'updates orphan sponsorship status' do
    service = UpdateOrphanSponsorshipStatus.new(orphan, 'sponsored')

    expect{ service.call }.to change(orphan, :sponsorship_status).
      to('sponsored')
  end
end
