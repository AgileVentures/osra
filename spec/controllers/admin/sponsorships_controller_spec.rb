require 'rails_helper'
include Devise::TestHelpers

describe Admin::SponsorshipsController, type: :controller do

  let(:orphan) { instance_double Orphan }
  let(:sponsor) { instance_double Sponsor, id: 1 }

  before(:each) do
    @admin_user = AdminUser.create(email: 'admin@example.com',
                                   password: 'password',
                                   password_confirmation: 'password')
    sign_in @admin_user

    allow(Sponsor).to receive(:find).with('1').and_return(sponsor)
    allow(Orphan).to receive(:find).with('1').and_return(orphan)
  end

  describe 'inactivate' do

    let(:sponsorship) { instance_double Sponsorship, id: 1, sponsor: sponsor, orphan: orphan }

    before(:each) do
      allow(Sponsorship).to receive(:find).with('1').and_return(sponsorship)
      allow(sponsorship).to receive(:inactivate)
    end

    it 'assigns instance variables' do
      put :inactivate, { id: 1, sponsor_id: sponsor.id }
      expect(assigns :sponsor).to eq sponsor
      expect(assigns :sponsorship).to eq sponsorship
    end

    it 'calls #inactivate on sponsorship' do
      put :inactivate, { id: sponsorship.id, sponsor_id: sponsor.id }
      expect(sponsorship).to have_received :inactivate
    end

    it 'sets flash[:success] message' do
      put :inactivate, { id: sponsorship.id, sponsor_id: sponsor.id }
      expect(flash[:success]).to eq 'Sponsorship link was successfully terminated'
    end

    it 'redirects to sponsor show view' do
      put :inactivate, { id: sponsorship.id, sponsor_id: sponsor.id }
      expect(response).to redirect_to admin_sponsor_path(sponsor)
    end
  end

  describe 'create' do
    before(:each) do
      allow(Sponsorship).to receive(:create!)
      post :create, { orphan_id: 1, sponsor_id: 1 }
    end

    it 'assigns instance variables' do
      expect(assigns :orphan).to eq orphan
      expect(assigns :sponsor).to eq sponsor
    end

    it 'calls .create on Sponsorship' do
      expect(Sponsorship).to have_received(:create!).with(sponsor: sponsor, orphan: orphan)
    end

    it 'sets flash[:success] message' do
      expect(flash[:success]).to eq 'Sponsorship link was successfully created'
    end

    it 'redirects to sponsor show view' do
      expect(response).to redirect_to admin_sponsor_path(sponsor)
    end
  end
end
