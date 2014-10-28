require 'rails_helper'
include Devise::TestHelpers

describe Admin::PendingOrphanListsController, type: :controller do
  let(:pending_orphan_list) { instance_double PendingOrphanList, destroy!: true }

  before(:each) do
    sign_in instance_double(AdminUser)

    allow(PendingOrphanList).to receive(:find).and_return pending_orphan_list
    delete :destroy, id: 1, partner_id: 1
  end

  describe 'destroy' do
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
