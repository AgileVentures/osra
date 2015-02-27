require 'rails_helper'

RSpec.describe Hq::SponsorshipsController, type: :controller do
  let(:sponsorship) {create :sponsorship, active: true}

  before :each do
    sign_in instance_double(AdminUser)
  end

  specify "#inactivate" do
    expect(Sponsorship).to receive(:find).and_return(sponsorship)
    put :inactivate, id: sponsorship.id, sponsor_id: sponsorship.sponsor_id, sponsorship: {end_date: Date.current}

    expect(sponsorship.active).to be false
    expect(response).to redirect_to hq_sponsor_path(sponsorship.sponsor_id)
  end

  specify "#destroy" do
    expect(Sponsorship).to receive(:find).and_return(sponsorship)
    expect(sponsorship).to receive(:destroy).and_return(true)
    delete :destroy, id: sponsorship.id, sponsor_id: sponsorship.sponsor_id

    expect(response).to redirect_to hq_sponsor_path(sponsorship.sponsor_id)
  end
end