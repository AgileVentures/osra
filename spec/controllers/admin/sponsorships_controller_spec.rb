require 'rails_helper'
include Devise::TestHelpers

describe Admin::SponsorshipsController, type: :controller do

  let(:sponsor) { instance_double Sponsor }
  let(:sponsorship) { instance_double Sponsorship }

  before(:each) do
    sign_in instance_double(AdminUser)
    allow(Sponsor).to receive(:find).with('1').and_return sponsor
  end

  describe 'inactivate' do

    before(:each) do
      expect(sponsor).to receive_message_chain(:sponsorships, :find)
    end

    context 'when successful' do

      before(:each) do
        expect(InactivateSponsorship).to receive_message_chain(:new, :call).
          and_return true
        put :inactivate, { id: 1, sponsor_id: 1, end_date: '1-1-2017' }
      end

      it 'sets flash[:success] message' do
        expect(flash[:success]).not_to be_nil
        expect(flash[:warning]).to be_nil
      end

      it 'redirects to sponsor show view' do
        expect(response).to redirect_to admin_sponsor_path(sponsor)
      end
    end

    context 'when unsuccessful' do

      before(:each) do
        expect(InactivateSponsorship).to receive_message_chain(:new, :call).
          and_raise('BOOM')
        put :inactivate, { id: 1, sponsor_id: 1, end_date: '1-1-2017' }
      end

      it 'sets flash[:warning] message' do
        expect(flash[:success]).to be_nil
        expect(flash[:warning]).to eq 'BOOM'
      end

      it 'redirects to sponsor show view' do
        expect(response).to redirect_to admin_sponsor_path(sponsor)
      end
    end
  end

  describe 'destroy' do

    before(:each) do
      allow(sponsor).to receive_message_chain(:sponsorships, :find)
    end

    context 'when successful' do

      before(:each) do
        expect(DestroySponsorship).to receive_message_chain(:new, :call).
          and_return true
        delete :destroy, { id: 1, sponsor_id: 1 }
      end

      it 'sets flash[:success] message' do
        expect(flash[:success]).not_to be_nil
        expect(flash[:warning]).to be_nil
      end

      it 'redirects to sponsor show view' do
        expect(response).to redirect_to admin_sponsor_path(sponsor)
      end
    end

    context 'when unsuccessful' do

      before(:each) do
        expect(DestroySponsorship).to receive_message_chain(:new, :call).
          and_raise('BOOM')
        delete :destroy, { id: 1, sponsor_id: 1 }
      end

      it 'sets flash[:warning] message' do
        expect(flash[:success]).to be_nil
        expect(flash[:warning]).to eq 'BOOM'
      end

      it 'redirects to sponsor show view' do
        expect(response).to redirect_to admin_sponsor_path(sponsor)
      end
    end
  end

  describe 'create' do

    before :each do
      allow(sponsor).to receive_message_chain(:sponsorships, :build)
    end

    context 'when successful' do

      before(:each) do
        expect(CreateSponsorship).to receive_message_chain(:new, :call).
          and_return true
        post :create, { id: 1, sponsor_id: 1, start_date: '1-1-2000' }
      end

      it 'sets flash[:success] message' do
        expect(flash[:success]).not_to be_nil
        expect(flash[:warning]).to be_nil
      end

      it 'redirects to sponsor show view' do
        expect(response).to redirect_to admin_sponsor_path(sponsor)
      end
    end

    context 'when unsuccessful' do

      before(:each) do
        expect(CreateSponsorship).to receive_message_chain(:new, :call).
          and_raise('BOOM')
        post :create, { id: 1, sponsor_id: 1, start_date: '1-1-2000' }
      end

      it 'sets flash[:warning] message' do
        expect(flash[:success]).to be_nil
        expect(flash[:warning]).to eq 'BOOM'
      end

      it 'redirects to new sponsorship view' do
        expect(response).to redirect_to new_sponsorship_path(sponsor, scope: 'eligible_for_sponsorship')
      end
    end
  end
end
