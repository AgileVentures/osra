require 'rails_helper'

RSpec.describe Hq::PendingOrphanListsController, type: :controller do
  let(:partner) { build_stubbed :partner }
  let(:pending_orphan_list) { instance_double PendingOrphanList, spreadsheet: 'sheet', destroy!: true }
  let(:orphan_importer) { double }
  # let(:orphan_lists) { double }
  # let(:orphan_list) { double }
  # let(:pending_orphans) { double }



  before :each do
    sign_in instance_double(AdminUser)

    allow(Partner).to receive(:find).with(partner.id.to_s).and_return partner
  end

  describe 'upload' do
    context 'when partner is inactive' do
      it 'redirects to partner if partner not active' do
        expect(partner).to receive(:active?).and_return false
        get :upload, partner_id: partner.id

        expect(response).to redirect_to hq_partner_path(partner)
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

        expect(response).to redirect_to hq_partner_path(partner.id)
      end
    end

    context 'when no spreadsheet is specified' do

      before do
        allow(partner).to receive(:active?).and_return true
        post :validate, partner_id: partner.id
      end

      it 'redirects back to the current page' do
        expect(response).to redirect_to upload_hq_partner_pending_orphan_lists_path(partner.id)
      end

    end

    context 'when partner is active' do
      let(:orphan_list_params) { { spreadsheet: fixture_file_upload('one_orphan_xls.xls') } }
      let(:invalid_orphan_list_params) { { spreadsheet: fixture_file_upload('three_invalid_orphans_xlsx.xlsx') } }

      before do
        allow(partner).to receive(:active?).and_return true
        allow(pending_orphan_list).to receive :save!
        allow(pending_orphan_list).to receive :pending_orphans=
        allow(orphan_importer).to receive :extract_orphans
        allow(orphan_importer).to receive(:valid?).and_return true
      end

      context "valid orphan_list" do
        before :each do
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
        before :each do
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

end
