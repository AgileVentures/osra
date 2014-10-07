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
      let(:partner) { FactoryGirl.create :partner }

      before(:each) do
        expect(Partner).to receive(:find).at_least(:once).with('1').and_return(partner)
        expect(partner).to receive(:active?).and_return true
        allow(request.env['warden']).to receive(:authenticate).and_return(instance_double AdminUser)
      end

      it 'determines that partner is active' do
        get :new, partner_id: 1
        expect(response).not_to redirect_to admin_partner_path(1)
      end
    end
  end
end
