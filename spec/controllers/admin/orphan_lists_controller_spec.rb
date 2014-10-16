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

  describe 'create' do
    let(:partner) { instance_double Partner }
    let(:orphan_list) { FactoryGirl.build :orphan_list }#{ double OrphanList }
    let(:orphan_lists) { [orphan_list] }
    let(:orphan_list_params) { { params: 'params' } }

    before do
      allow(Partner).to receive(:find).with('1').and_return partner
      allow(partner).to receive(:orphan_lists).and_return orphan_lists
      allow(orphan_lists).to receive(:build).and_return orphan_list
      allow(orphan_list).to receive(:orphan_count=).with 0
      allow(orphan_list).to receive(:save)
    end

    it 'sets @partner' do
      post :create, { partner_id: 1, orphan_list: orphan_list_params }
      expect(assigns :partner).to eq partner
    end

    it 'sets @orphan_list to modified orphan_list_params' do
      post :create, { partner_id: 1, orphan_list: orphan_list_params }
      modified_orphan_list = orphan_list
      modified_orphan_list.orphan_count = 0
      modified_orphan_list.sequential_id = 1
      expect(assigns :orphan_list).to eq modified_orphan_list
    end

    context 'on successful save' do
      before(:each) do
        allow(orphan_list).to receive(:save).and_return true
        allow(orphan_list).to receive(:osra_num).and_return 1
        post :create, { partner_id: 1, orphan_list: orphan_list_params }
      end

      it 'sets the flash' do
        expect(flash[:notice]).to eq 'Orphan List (1) was successfully imported.'
      end

      it 'redirects to partner page' do
        expect(response).to redirect_to admin_partner_path(partner)
      end
    end

    context 'on failed save' do
      before(:each) do
        allow(orphan_list).to receive(:save).and_return false
        post :create, { partner_id: 1, orphan_list: orphan_list_params }
      end

      it 'renders :new' do
        expect(response).to render_template :new
      end
    end
  end
end
