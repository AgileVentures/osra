require 'rails_helper'
include Devise::TestHelpers

describe Admin::OrphanListsController, type: :controller do

  before(:each) do
    sign_in instance_double(AdminUser)
  end

  describe 'new' do

    context 'when partner is inactive' do
      let(:partner) { instance_double Partner, active?: false }

      before(:each) do
        expect(Partner).to receive(:find).with('1').and_return(partner)
        expect(partner).to receive(:active?)
      end

      it 'sets the alert flash' do
        get :new, partner_id: 1
        expect(flash[:alert]).to eq 'Partner is not Active. Orphan List cannot be uploaded.'
      end

      it 'redirects to partner if partner is inactive' do
        get :new, partner_id: 1
        expect(response).to redirect_to admin_partner_path(1)
      end
    end

    context 'when partner is active' do
      let(:partner) { instance_double(Partner).as_null_object }

      before(:each) do
        expect(Partner).to receive(:find).with('1').and_return(partner)
        expect(partner).to receive(:active?).and_return true
      end

      # it 'calls partner#orphan_lists' do
      #   expect(InheritedResources::Actions).to receive(:new!)
      #   get :new, partner_id: 1
      # end
    end
  end
end
