require 'rails_helper'

RSpec.describe PendingOrphanListsController, type: :controller do
  let(:partner) { build_stubbed :partner }
  let(:pending_orphan_list) { instance_double PendingOrphanList, id: 1, spreadsheet: 'sheet', destroy: true, destroy!: true }
  let(:orphan_importer) { double }
  let(:orphan_lists) { double }
  let(:orphan_list) { double }
  let(:pending_orphans) { double }

  before :each do
    sign_in instance_double(AdminUser)

    allow(Partner).to receive(:find).with(partner.id.to_s).and_return partner
    allow(PendingOrphanList).to receive(:new).and_return pending_orphan_list
    allow(PendingOrphanList).to receive(:find).with(pending_orphan_list.id.to_s).and_return pending_orphan_list
    allow(OrphanImporter).to receive(:new).and_return orphan_importer

    allow(partner).to receive(:orphan_lists).and_return orphan_lists
    allow(orphan_lists).to receive(:create!).and_return orphan_list
    allow(orphan_lists).to receive(:build).and_return orphan_list
  end

  describe 'upload' do
    context 'when partner is inactive' do
      it 'redirects to partner if partner not active' do
        expect(partner).to receive(:active?).and_return false
        get :upload, partner_id: partner.id

        expect(response).to redirect_to partner_path(partner)
      end
    end

    context 'when partner is active' do
      before(:each) do
        expect(partner).to receive(:active?).and_return true

        get :upload, partner_id: partner.id
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
        post :validate, partner_id: partner.id

        expect(response).to redirect_to partner_path(partner.id)
      end
    end

    context 'when no spreadsheet is specified' do

      before do
        allow(partner).to receive(:active?).and_return true
        post :validate, partner_id: partner.id
      end

      it 'redirects back to the current page' do
        expect(response).to redirect_to upload_partner_pending_orphan_lists_path(partner.id)
      end
    end

    context 'when partner is active' do
      let(:orphan_list_params) { { spreadsheet: fixture_file_upload('one_orphan_xls.xls') } }
      let(:invalid_orphan_list_params) { { spreadsheet: fixture_file_upload('two_orphans_first_invalid_xlsx.xlsx') } }

      before do
        allow(partner).to receive(:active?).and_return true
        allow(pending_orphan_list).to receive :save!
        allow(pending_orphan_list).to receive :pending_orphans=
        allow(orphan_importer).to receive(:extract_orphans)
      end

      context "valid orphan_list" do
        before :each do
          expect(orphan_importer).to receive(:valid?).and_return true
          post :validate, partner_id: partner.id, pending_orphan_list: orphan_list_params
        end


        it 'sets instance variables' do
          expect(assigns :partner).to eq partner
          expect(assigns :pending_orphan_list).to eq pending_orphan_list
        end

        it 'saves pending_orphan_list' do
          expect(pending_orphan_list).to have_received :save!
        end

        it 'renders :valid_list' do
          expect(response).to render_template :valid_list
        end
      end

      context "invalid orphan_list" do
        before do
          expect(orphan_importer).to receive(:valid?).and_return false
          post :validate, partner_id: partner.id, pending_orphan_list: invalid_orphan_list_params
        end

        it 'does not save invalid_orphan_list_params' do
          expect(pending_orphan_list).not_to have_received :save!
        end

        it 'renders :invalid_list' do
          expect(response).to render_template :invalid_list
        end
      end
    end
  end

  describe 'import' do
    let(:orphan) { instance_double Orphan, :save! => true }
    let(:pending_orphan) { instance_double PendingOrphan, :save! => true }
    let(:orphans_to_import) { [orphan] }

    before do
      allow(orphan_list).to receive :orphan_count=
      allow(orphan_list).to receive(:orphans).and_return orphans_to_import
      allow(orphan_list).to receive :save!
      allow(orphan_list).to receive :orphan_count
      allow(pending_orphans).to receive(:each).and_yield(pending_orphan)
      allow(orphan_list).to receive :osra_num
      allow(pending_orphan_list).to receive(:pending_orphans).and_return pending_orphans
      allow(pending_orphan).to receive(:to_orphan).and_return orphan
    end

    context 'when orphan records are valid' do
      before do
        allow(orphans_to_import).to receive_message_chain(:map, :all?).and_return true
        post :import, partner_id: partner.id, orphan_list: { pending_id: 1 }
      end

      it 'sets instance variables' do
        expect(assigns :partner).to eq partner
        expect(assigns :pending_orphan_list).to eq pending_orphan_list
      end

      it 'saves orphan_list' do
        expect(orphan_list).to (have_received :save!)
      end

      it 'destroys pending_orphan_list' do
        expect(pending_orphan_list).to have_received :destroy
      end

      it 'sets flash message' do
        expect(flash[:notice]).to include('was successfully imported.')
      end

      it 'redirects to partner' do
        expect(response).to redirect_to partner_path(partner)
      end
    end
  end

  describe 'destroy' do
    it 'removes existing pending_orphan_list' do
      delete :destroy, id: pending_orphan_list.id, partner_id: partner.id

      expect(response).to redirect_to partner_path(partner)
    end
  end
end
