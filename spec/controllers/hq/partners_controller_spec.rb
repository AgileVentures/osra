require 'rails_helper'
class NyuksController < Hq::PartnersController; end

RSpec.describe Hq::PartnersController, type: :controller do
  describe 'authentication' do
    controller NyuksController do
      def foobar_action
        render nothing: true
      end
    end

    it 'checks for admin_user session' do
      routes.draw { get 'foobar_action', to: 'nyuks#foobar_action' }
      expect(controller).to be_a_kind_of(Hq::PartnersController)
      expect_any_instance_of(Hq::PartnersController).to receive :authenticate_admin_user!
      get :foobar_action
    end
  end

end

RSpec.describe Hq::PartnersController, type: :controller do
  before :each do
    sign_in instance_double(AdminUser)
    @partner = build_stubbed :partner
    expect(Partner).to receive(:find).and_return(@partner)
  end

  specify 'editing renders the edit view' do
    get :edit, id: @partner.id
    expect(response).to render_template 'edit'
  end

  specify 'unsuccessful update renders the edit view' do
    expect(@partner).to receive(:save).and_return(false)
    patch :update, id: @partner.id
    expect(response).to render_template 'edit'
  end

  specify 'successful update redirects to the show view' do
    expect(@partner).to receive(:save).and_return(true)
    patch :update, id: @partner.id
    expect(response).to redirect_to(hq_partner_path(@partner))
  end
end
