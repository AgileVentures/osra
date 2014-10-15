require 'rails_helper'
include Devise::TestHelpers

describe Admin::OrphanListsController, type: :controller do

  let(:partner) { instance_double Partner }
  let(:pending_orphan_list) { instance_double PendingOrphanList }

  before(:each) do
    sign_in instance_double(AdminUser)
    allow(Partner).to receive(:find).with('1').and_return partner
    allow(PendingOrphanList).to receive(:new).and_return pending_orphan_list
  end

  describe 'upload' do
    it 'redirects to partner if partner not active' do
      expect(partner).to receive(:active?).and_return false
      get :upload, partner_id: 1, pending_orphan_list: [spreadsheet: 'sheet']
      expect(response).to redirect_to admin_partner_path(1)
    end

    it 'sets instance variables' do
      expect(partner).to receive(:active?).and_return true
      get :upload, partner_id: 1
      expect(assigns :partner).to eq partner
    end

    it 'renders :upload' do
      expect(partner).to receive(:active?).and_return true
      get :upload, partner_id: 1
      expect(response).to render_template :upload
    end
  end

  describe 'validate'

  describe 'import'
end
