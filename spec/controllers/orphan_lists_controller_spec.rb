require 'rails_helper'

RSpec.describe OrphanListsController, type: :controller do
  let(:partner) {build_stubbed :partner}
  let(:orphan_lists) {build_stubbed_list :orphan_list, 3}

  before :each do
    sign_in instance_double(AdminUser)
  end

  describe "index" do
    it "assigns correct instances" do
      expect(Partner).to receive(:find).with(partner.id.to_s).and_return(partner)
      expect(partner).to receive(:orphan_lists).and_return(orphan_lists)

      get :index, partner_id: partner.id

      expect(assigns(:partner)).to eq partner
      expect(assigns(:orphan_lists)).to eq orphan_lists
      expect(response).to render_template 'index'
    end
  end
end
