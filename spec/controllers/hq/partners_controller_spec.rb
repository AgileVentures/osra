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

  describe 'while signed-in' do
    before :each do
      sign_in instance_double(AdminUser)
    end

    describe 'GET #show' do
      before :each do
        FactoryGirl.create(:partner)
      end

      example 'invalid :id should redirect & set flash' do
        get :show, id: (Partner.all.count + 1)
        expect(response.status).to be 302
        expect(response).to redirect_to hq_partners_path
        expect(flash[:error]).to match /Cannot find Partner/
      end

      example 'valid :id should not redirect nor set flash' do
        get :show, id: Partner.first.id
        expect(response.status).to_not be 302
        expect(flash[:error]).to_not match /Cannot find Partner/
      end
    end
  end
end
