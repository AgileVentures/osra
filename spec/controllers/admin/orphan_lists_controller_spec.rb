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
      get :upload, partner_id: 1
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

  describe 'validate' do
    let(:orphan_list_params) { { :spreadsheet => fixture_file_upload('one_orphan_xls.xls') } }
    let(:orphan_lists) { double }

    before do
      allow(partner).to receive(:active?).and_return true
      allow(pending_orphan_list).to receive :save!
      allow(partner).to receive(:orphan_lists).and_return orphan_lists
      allow(orphan_lists).to receive :build
    end

    it 'redirects to partner if partner not active' do
      expect(partner).to receive(:active?).and_return false
      post :validate, partner_id: 1
      expect(response).to redirect_to admin_partner_path(1)
    end

    it 'sets instance variables' do
      expect(pending_orphan_list).to receive(:save!)
      post :validate, partner_id: 1, pending_orphan_list: orphan_list_params
      expect(assigns :partner).to eq partner
      expect(assigns :pending_orphan_list).to eq pending_orphan_list
    end

    it 'saves pending_orphan_list' do
      expect(pending_orphan_list).to receive :save!
      post :validate, partner_id: 1, pending_orphan_list: orphan_list_params
    end

    it 'renders :validate' do
      post :validate, partner_id: 1, pending_orphan_list: orphan_list_params
      expect(response).to render_template :validate
    end
  end

  describe 'import'
end
