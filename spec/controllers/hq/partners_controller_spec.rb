require 'rails_helper'

RSpec.describe Hq::PartnersController, type: :controller do
  before :each do
    sign_in instance_double(AdminUser)
  end

  context '#new and #create' do
    let(:partner) { build_stubbed :partner }

    before :each do
      controller.instance_variable_set(:@partner, partner)
    end

    specify 'successful create redirects to the show view' do
      expect(partner).to receive(:save).and_return(true)
      post :create, partner: partner.attributes
      expect(response).to redirect_to hq_partner_path(partner)
    end

    specify 'unsuccessful create renders the new view' do
      expect(partner).to receive(:save).and_return(false)
      post :create, partner: partner.attributes
      expect(response).to render_template 'new'
    end
  end

  context '#edit and #update' do
    before :each do
      @partner = build_stubbed :partner
      expect(Partner).to receive(:find).and_return(@partner)
    end

    specify 'editing renders the edit view' do
      get :edit, id: @partner.id
      expect(response).to render_template 'edit'
    end

    specify 'unsuccessful update renders the edit view' do
      expect(@partner).to receive(:save).and_return(false)
      patch :update, id: @partner.id, partner: @partner.attributes
      expect(response).to render_template 'edit'
    end

    specify 'successful update redirects to the show view' do
      expect(@partner).to receive(:save).and_return(true)
      patch :update, id: @partner.id, partner: @partner.attributes
      expect(response).to redirect_to(hq_partner_path(@partner))
    end
  end

  describe '#index' do
    specify 'pagination' do
      expect(Partner).to receive(:paginate).with(page: "2")
      get :index, page: "2"
    end
  end
end
