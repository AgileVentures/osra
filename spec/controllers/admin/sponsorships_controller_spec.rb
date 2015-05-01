require 'rails_helper'
include Devise::TestHelpers

describe Admin::SponsorshipsController, type: :controller do

  let(:sponsor) { instance_double Sponsor }
  let(:orphan) { instance_double Orphan }
  let(:sponsorship) { instance_double Sponsorship }

  before(:each) do
    sign_in instance_double(AdminUser)
    allow(Sponsor).to receive(:find).with('1').and_return sponsor
    allow(Orphan).to receive(:find).with('1').and_return orphan
  end

  describe '#inactivate' do

    let(:sponsorship_inactivator) { instance_double InactivateSponsorship }

    before(:each) do
      expect(sponsor).to receive_message_chain(:sponsorships, :find)
      allow(InactivateSponsorship).to receive(:new).
        and_return sponsorship_inactivator
    end

    context 'when successful' do

      before(:each) do
        expect(sponsorship_inactivator).to receive(:call).and_return true

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
        expect(sponsorship_inactivator).to receive(:call).and_return false
        expect(sponsorship_inactivator).to receive(:error_msg).and_return 'No go'

        put :inactivate, { id: 1, sponsor_id: 1, end_date: '1-1-2017' }
      end

      it 'sets flash[:warning] message' do
        expect(flash[:success]).to be_nil
        expect(flash[:warning]).to eq 'No go'
      end

      it 'redirects to sponsor show view' do
        expect(response).to redirect_to admin_sponsor_path(sponsor)
      end
    end
  end

  describe '#destroy' do

    let(:sponsorship_destructor) { instance_double DestroySponsorship }

    before(:each) do
      allow(sponsor).to receive_message_chain(:sponsorships, :find)
      allow(DestroySponsorship).to receive(:new).
        and_return(sponsorship_destructor)
    end

    context 'when successful' do

      before(:each) do
        expect(sponsorship_destructor).to receive(:call).and_return true

        delete :destroy, { id: 1, sponsor_id: 1 }
      end

      it 'sets flash[:success] message' do
        expect(flash[:success]).to eq 'Sponsorship record was successfully destroyed.'
        expect(flash[:warning]).to be_nil
      end

      it 'redirects to sponsor show view' do
        expect(response).to redirect_to admin_sponsor_path(sponsor)
      end
    end

    context 'when unsuccessful' do

      before(:each) do
        expect(sponsorship_destructor).to receive(:call).and_return false
        expect(sponsorship_destructor).to receive(:error_msg).and_return 'No go'

        delete :destroy, { id: 1, sponsor_id: 1 }
      end

      it 'sets flash[:warning] message' do
        expect(flash[:success]).to be_nil
        expect(flash[:warning]).to eq 'No go'
      end

      it 'redirects to sponsor show view' do
        expect(response).to redirect_to admin_sponsor_path(sponsor)
      end
    end
  end

  describe '#create' do

    let(:sponsorship_creator) { instance_double CreateSponsorship }

    before :each do
      allow(sponsor).to receive_message_chain(:sponsorships, :build)
      allow(CreateSponsorship).to receive(:new).and_return(sponsorship_creator)
    end

    context 'when successful' do
      before(:each) do
        expect(sponsorship_creator).to receive(:call).and_return true
      end

      context 'when request was fulfilled' do
        before(:each) do
          expect(sponsor).to receive(:request_fulfilled).and_return true

          post :create, { id: 1, orphan_id: 1, sponsor_id: 1, start_date: '1-1-2013' }
        end

        it 'sets flash[:success] message' do
          expect(flash[:success]).not_to be_nil
          expect(flash[:warning]).to be_nil
        end

        it 'redirects to sponsor show view' do
          expect(response).to redirect_to admin_sponsor_path(sponsor)
        end
      end

      context 'when request was not fulfilled' do
        before(:each) do
          expect(sponsor).to receive(:request_fulfilled).and_return false
          expect(orphan).to receive(:name).and_return 'first orphan'

          post :create, { id: 1, orphan_id: 1, sponsor_id: 1, start_date: '1-1-2013' }
        end

        it 'sets flash[:warning] message' do
          expect(flash[:success]).not_to be_nil
          expect(flash[:warning]).to be_nil
        end

        it 'redirects back to sponsorship view' do
          expect(response).to redirect_to new_sponsorship_path(sponsor, scope: 'eligible_for_sponsorship')
        end
      end
    end

    context 'when unsuccessful' do
      before(:each) do
        expect(sponsorship_creator).to receive(:call).and_return false
        expect(sponsorship_creator).to receive(:error_msg).and_return 'No go'

        post :create, { id: 1, orphan_id: 1, sponsor_id: 1, start_date: '1-1-2013' }
      end

      it 'sets flash[:warning] message' do
        expect(flash[:success]).to be_nil
        expect(flash[:warning]).to eq 'No go'
      end

      it 'redirects to new sponsorship view' do
        expect(response).to redirect_to new_sponsorship_path(sponsor, scope: 'eligible_for_sponsorship')
      end
    end
  end
end
