require 'rails_helper'

RSpec.describe SponsorshipsController, type: :controller do
  let(:sponsorship) {build_stubbed :sponsorship, active: true}
  let(:orphan) { instance_double Orphan }
  let(:sponsor) { instance_double Sponsor }

  before :each do
    sign_in instance_double(AdminUser)
    allow(Sponsor).to receive(:find).with('1').and_return sponsor
    allow(Orphan).to receive(:find).with('1').and_return orphan
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
          expect(flash[:error]).to be_nil
        end

        it 'redirects to sponsor show view' do
          expect(response).to redirect_to sponsor_path(sponsor)
        end
      end

      context 'when request was not fulfilled' do
        before(:each) do
          expect(sponsor).to receive(:request_fulfilled).and_return false
          expect(orphan).to receive(:full_name).and_return 'first orphan'

          post :create, { id: 1, orphan_id: 1, sponsor_id: 1, start_date: '1-1-2013' }
        end

        it 'sets flash[:error] message' do
          expect(flash[:success]).not_to be_nil
          expect(flash[:error]).to be_nil
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

      it 'sets flash[:error] message' do
        expect(flash[:success]).to be_nil
        expect(flash[:error]).to eq 'No go'
      end

      it 'redirects to new sponsorship view' do
        expect(response).to redirect_to new_sponsorship_path(sponsor, scope: 'eligible_for_sponsorship')
      end
    end
  end

  context "#inactivate" do
    let(:sponsorship_inactivator) {instance_double InactivateSponsorship}
    let(:date) {"2015-01-01"}

    before :each do
      expect(Sponsorship).to receive(:find).with(sponsorship.id.to_s).and_return(sponsorship)
      expect(InactivateSponsorship).to receive(:new)
        .with(sponsorship: sponsorship, end_date: date)
        .and_return(sponsorship_inactivator)
    end

    specify "successful" do
      expect(sponsorship_inactivator).to receive(:call).and_return(true)
      put :inactivate, id: sponsorship.id, sponsorship: {end_date: date}

      expect(response).to redirect_to sponsor_path(sponsorship.sponsor)
      expect(flash[:success]).to_not be_nil
    end

    specify "unsuccessful" do
      expect(sponsorship_inactivator).to receive(:call).and_return(false)
      expect(sponsorship_inactivator).to receive(:error_msg).and_return("error mess")
      put :inactivate, id: sponsorship.id, sponsorship: {end_date: date}

      expect(response).to redirect_to sponsor_path(sponsorship.sponsor)
      expect(flash[:error]).to eq "error mess"
    end
  end

  context "#destroy" do
    let(:sponsorship_destructor) {instance_double DestroySponsorship}

    before :each do
      expect(Sponsorship).to receive(:find).with(sponsorship.id.to_s).and_return(sponsorship)
      expect(DestroySponsorship).to receive(:new)
        .with(sponsorship).and_return(sponsorship_destructor)
    end

    specify "successful" do
      expect(sponsorship_destructor).to receive(:call).and_return(true)
      delete :destroy, id: sponsorship.id

      expect(response).to redirect_to sponsor_path(sponsorship.sponsor)
      expect(flash[:success]).to_not be_nil
    end

    specify "unsuccessful" do
      expect(sponsorship_destructor).to receive(:call).and_return(false)
      expect(sponsorship_destructor).to receive(:error_msg).and_return("error mess")
      delete :destroy, id: sponsorship.id

      expect(response).to redirect_to sponsor_path(sponsorship.sponsor)
      expect(flash[:error]).to eq "error mess"
    end
  end
end
