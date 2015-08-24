require 'rails_helper'

RSpec.describe Hq::PendingOrphanListsController, type: :controller do
  let(:partner) { instance_double Partner }

  before :each do
    sign_in instance_double(AdminUser)

    allow(Partner).to receive(:find).with('1').and_return partner
  end

  describe 'upload' do
    context 'when partner is inactive' do
      it 'redirects to partner if partner not active' do
        expect(partner).to receive(:active?).and_return false
        get :upload, partner_id: 1

        expect(response).to redirect_to hq_partner_path(partner)
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

end
