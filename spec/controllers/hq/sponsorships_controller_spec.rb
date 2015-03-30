require 'rails_helper'

RSpec.describe Hq::SponsorshipsController, type: :controller do
  let(:sponsorship) {create :sponsorship, active: true}

  before :each do
    sign_in instance_double(AdminUser)
  end

  specify "#inactivate" do
    expect(Sponsorship).to receive(:find).and_return(sponsorship)
    expect(sponsorship).to receive(:update!)
    put :inactivate, id: sponsorship.id, sponsorship: {end_date: Date.current}

    expect(response).to redirect_to hq_sponsor_path(sponsorship.sponsor)
    expect(flash[:success]).to_not be_nil
  end

  specify "#destroy" do
    expect(Sponsorship).to receive(:find).and_return(sponsorship)
    expect(sponsorship).to receive(:destroy!)
    delete :destroy, id: sponsorship.id

    expect(response).to redirect_to hq_sponsor_path(sponsorship.sponsor)
    expect(flash[:success]).to_not be_nil
  end
end