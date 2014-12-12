require 'rails_helper'
include Devise::TestHelpers

describe Admin::PendingOrphanListsController, type: :controller do
  describe 'import' do
    let(:partner) { instance_double Partner }
    let(:pending_orphan_list) { instance_double PendingOrphanList, :destroy => true, :spreadsheet => true }
    let(:orphan_list) { double OrphanList, :orphans= => true, :osra_num => 5, :orphan_count => 5 }
    let(:orphan) { instance_double Orphan }

    before(:each) do
      sign_in instance_double(AdminUser)
      expect(Partner).to receive(:find).with('1').and_return partner
      expect(partner).to receive_message_chain(:orphan_lists, :build).and_return orphan_list
      expect(PendingOrphanList).to receive(:find).with('1').and_return pending_orphan_list
      expect(controller).to receive(:get_orphans_from)
      expect(pending_orphan_list).to receive(:destroy)
    end

    context 'when orphan list contains valid non-duplicate records' do
      before(:each) do
        expect(controller).to receive(:check_for_duplicates).and_return []
        expect(controller).to receive(:check_for_object_validity).and_return []
        expect(controller).to receive(:db_persist)
        allow(orphan_list).to receive(:orphans).and_return [orphan]
        post :import, partner_id: 1, orphan_list: { pending_id: 1 }
      end

      it 'reports no errors' do
        expect(flash[:error]).to be_nil
      end

      it 'sets notice flash' do
        expect(flash[:notice]).not_to be_nil
      end
    end

    context 'when orphan list contains valid duplicate records' do
      before(:each) do
        expect(controller).to receive(:check_for_duplicates).and_return 'File contains duplicate records.'
        expect(controller).to receive(:check_for_object_validity).and_return []
        expect(controller).not_to receive(:db_persist)
        allow(orphan_list).to receive(:orphans).and_return [orphan]
        post :import, partner_id: 1, orphan_list: { pending_id: 1 }
      end

      it 'reports errors' do
        expect(flash[:error]).to include 'File contains duplicate records.'
      end

      it 'does not set notice flash' do
        expect(flash[:notice]).to be_nil
      end
    end

    context 'when orphan list contains records that violate Orphan model validations' do
      before(:each) do
        expect(controller).to receive(:check_for_duplicates).and_return []
        expect(controller).to receive(:check_for_object_validity).and_return ['Error messages']
        expect(controller).not_to receive(:db_persist)
        allow(orphan_list).to receive(:orphans).and_return [orphan]
        post :import, partner_id: 1, orphan_list: { pending_id: 1 }
      end

      it 'reports errors' do
        expect(flash[:error]).to include 'Error messages'
      end

      it 'does not set notice flash' do
        expect(flash[:notice]).to be_nil
      end
    end

    context 'when the import process raises an exception' do
      before(:each) do
        allow(controller).to receive(:get_orphans_from).and_raise('KABOOOOOM!!!!')
        expect(controller).not_to receive(:check_for_duplicates)
        expect(controller).not_to receive(:check_for_object_validity)
        expect(controller).not_to receive(:db_persist)
        post :import, partner_id: 1, orphan_list: { pending_id: 1 }
      end

      it 'returns the exeption message' do
        expect(flash[:error]).to eq 'KABOOOOOM!!!!'
      end

      it 'redirects to the partner page' do
        expect(response).to redirect_to admin_partner_path(partner)
      end
    end
  end
end
