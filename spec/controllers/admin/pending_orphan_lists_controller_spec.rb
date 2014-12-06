require 'rails_helper'
include Devise::TestHelpers

describe Admin::PendingOrphanListsController, type: :controller do
  let(:pending_orphan_list) { instance_double PendingOrphanList, spreadsheet: 'sheet', destroy!: true }
  let(:partner) { instance_double Partner }
  let(:orphan_importer) { double }
  let(:orphan_lists) { double }
  let(:orphan_list) { double }
  let(:pending_orphans) { double }

  before(:each) do
    sign_in instance_double(AdminUser)

    allow(Partner).to receive(:find).with('1').and_return partner
    allow(PendingOrphanList).to receive(:new).and_return pending_orphan_list
    allow(PendingOrphanList).to receive(:find).with('1').and_return pending_orphan_list
    allow(OrphanImporter).to receive(:new).and_return orphan_importer

    allow(partner).to receive(:orphan_lists).and_return orphan_lists
    allow(orphan_lists).to receive(:create!).and_return orphan_list
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
      let(:orphan_list_params) { { spreadsheet: fixture_file_upload('one_orphan_xls.xls') } }

      before do
        allow(partner).to receive(:active?).and_return true
        allow(pending_orphan_list).to receive :save!
        allow(pending_orphan_list).to receive :pending_orphans=
        allow(orphan_importer).to receive :extract_orphans
        allow(orphan_importer).to receive(:valid?).and_return true
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
        expect(response).to render_template :valid_list
      end
    end
  end

  describe 'import' do
    let(:orphan) { instance_double Orphan, :save! => true }
    let(:orphans_to_import) { [orphan] }
    before do
      allow(orphan_list).to receive :orphan_count=
      allow(orphan_list).to receive(:orphans).and_return orphans_to_import
      allow(orphan_list).to receive :save!
      allow(pending_orphan_list).to receive :destroy
      allow(pending_orphans).to receive :each
      allow(orphan_list).to receive :osra_num
      allow(pending_orphan_list).to receive(:pending_orphans).and_return pending_orphans
    end

    context 'when orphan records are valid' do
      before do
        allow(orphans_to_import).to receive_message_chain(:map, :all?).and_return true
        post :import, partner_id: 1, orphan_list: { pending_id: 1 }
      end

      it 'sets instance variables' do
        expect(assigns :partner).to eq partner
        expect(assigns :pending_orphan_list).to eq pending_orphan_list
      end

      it 'saves orphan' do
        expect(orphan).to have_received(:save!)
      end

      it 'saves orphan_list' do
        expect(orphan_list).to (have_received :save!).twice
      end

      it 'destroys pending_orphan_list' do
        expect(pending_orphan_list).to have_received :destroy
      end

      it 'sets flash message' do
        expect(flash[:notice]).to include('was successfully imported.')
      end

      it 'redirects to partner' do
        expect(response).to redirect_to admin_partner_path(partner)
      end
    end

  end

  describe 'destroy' do

    before do
      delete :destroy, id: 1, partner_id: 1
    end

    it 'finds the pending orphan list' do
      expect(PendingOrphanList).to have_received(:find).with('1')
    end

    it 'calls destroy! on the pending orphan list' do
      expect(pending_orphan_list).to have_received :destroy!
    end

    it 'sets the flash message' do
      expect(flash[:alert]).to eq 'Orphan List was not imported.'
    end

    it 'redirects to partner page' do
      expect(response).to redirect_to admin_partner_path(1)
    end
  end
end
