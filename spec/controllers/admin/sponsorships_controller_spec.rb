require 'rails_helper'
include Devise::TestHelpers

describe Admin::SponsorshipsController, type: :controller do

  let(:orphan) { instance_double Orphan }
  let(:sponsor) { instance_double Sponsor }
  let(:sponsorship) { instance_double Sponsorship, sponsor: sponsor, orphan: orphan }

  before(:each) do
    sign_in instance_double(AdminUser)
    allow(sponsor).to receive(:id).and_return(1)
    allow(Sponsor).to receive(:find).with('1').and_return(sponsor)
    allow(Sponsorship).to receive(:find).with('1').and_return(sponsorship)
  end

  describe 'inactivate' do

    before(:each) do
      allow(sponsorship).to receive(:inactivate)
      put :inactivate, { id: 1, sponsor_id: 1 }
    end

    it 'assigns instance variables' do
      expect(assigns :sponsor).to eq sponsor
      expect(assigns :sponsorship).to eq sponsorship
    end

    it 'calls #inactivate on sponsorship' do
      expect(sponsorship).to have_received :inactivate
    end

    it 'sets flash[:success] message' do
      expect(flash[:success]).to eq 'Sponsorship link was successfully terminated'
    end

    it 'redirects to sponsor show view' do
      expect(response).to redirect_to admin_sponsor_path(sponsor)
    end
  end

  describe 'create' do
    before :each do
      allow(Sponsorship).to receive(:new).and_return(sponsorship)
    end

    it 'is successful' do
      allow(sponsorship).to receive(:save).and_return(true)
      post :create, { orphan_id: 1, sponsor_id: 1, sponsorship_start_date: '2002-02-02' }
      expect(flash[:warning]).to be_nil
      expect(flash[:success]).to eq 'Sponsorship link was successfully created.'
      expect(response).to redirect_to admin_sponsor_path(sponsor.id)
    end

    it 'is unsuccessful' do
      allow(sponsorship).to receive(:save).and_return(false)
      allow(sponsorship).to receive_message_chain(:errors, :full_messages).and_return('custom message 42')
      post :create, { orphan_id: 1, sponsor_id: 1, sponsorship_start_date: '2002-02-02' }
      expect(flash[:warning]).to eq 'custom message 42'
      expect(flash[:success]).to be_nil
      expect(response).to redirect_to new_sponsorship_path(sponsor.id, scope: 'eligible_for_sponsorship')
    end
  end
end
