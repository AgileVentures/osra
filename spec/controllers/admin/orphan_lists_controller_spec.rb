require 'rails_helper'
include Devise::TestHelpers

describe Admin::OrphanListsController, type: :controller do

  let(:partner) { instance_double Partner }
  let(:pending_orphan_list) { instance_double PendingOrphanList, spreadsheet: 'sheet' }
  let(:orphan_lists) { double }
  let(:orphan_list) { double }

  before(:each) do
    sign_in instance_double(AdminUser)

    allow(Partner).to receive(:find).with('1').and_return partner
    allow(PendingOrphanList).to receive(:new).and_return pending_orphan_list
    allow(partner).to receive(:orphan_lists).and_return orphan_lists
    allow(orphan_lists).to receive(:build).and_return orphan_list
  end

  describe 'upload' do
    context 'when partner is inactive' do
      it 'redirects to partner if partner not active' do
        expect(partner).to receive(:active?).and_return false
        get :upload, partner_id: 1
        expect(response).to redirect_to admin_partner_path(1)
      end
    end

    context 'when partner is active' do
      before(:each) do
        expect(partner).to receive(:active?).and_return true
        get :upload, partner_id: 1
      end

      it 'sets instance variables' do
        expect(assigns :partner).to eq partner
      end

      it 'renders :upload' do
        expect(response).to render_template :upload
      end
    end
  end

  describe 'validate' do
    context 'when partner is inactive' do
      it 'redirects to partner if partner not active' do
        expect(partner).to receive(:active?).and_return false
        post :validate, partner_id: 1
        expect(response).to redirect_to admin_partner_path(1)
      end
    end

    context 'when partner is active' do
      let(:orphan_list_params) { { :spreadsheet => fixture_file_upload('one_orphan_xls.xls') } }

      before do
        allow(partner).to receive(:active?).and_return true
        allow(pending_orphan_list).to receive :save!
        post :validate, partner_id: 1, pending_orphan_list: orphan_list_params
      end

      it 'sets instance variables' do
        expect(assigns :partner).to eq partner
        expect(assigns :pending_orphan_list).to eq pending_orphan_list
      end

      it 'saves pending_orphan_list' do
        expect(pending_orphan_list).to have_received :save!
      end

      it 'renders :validate' do
        expect(response).to render_template :validate
      end
    end
  end

  describe 'import' do
    before do
      allow(PendingOrphanList).to receive(:find).with('1').and_return pending_orphan_list
      allow(orphan_list).to receive :save!
      allow(pending_orphan_list).to receive :destroy
      post :import, partner_id: 1, orphan_list: { pending_id: 1 }
    end

    it 'sets instance variables' do
      expect(assigns :partner).to eq partner
      expect(assigns :pending_orphan_list).to eq pending_orphan_list
      expect(assigns :orphan_count).to eq 0
      expect(assigns :orphan_list).to eq orphan_list
    end

    it 'saves orphan_list' do
      expect(orphan_list).to have_received :save!
    end

    it 'destroys pending_orphan_list' do
      expect(pending_orphan_list).to have_received :destroy
    end

    it 'sets flash message' do
      expect(flash[:notice]).to eq 'Orphan List was successfully imported.'
    end

    it 'redirects to partner' do
      expect(response).to redirect_to admin_partner_path(partner)
    end
  end
end
