require 'rails_helper'
class NyuksController < Hq::PartnersController; end

RSpec.describe Hq::PartnersController, type: :controller do
  controller NyuksController do
    def foobar_action
      render nothing: true
    end
  end

  describe 'authentication' do
    it 'checks for admin_user session' do
      routes.draw { get 'foobar_action', to: 'nyuks#foobar_action' }
      expect(controller).to be_a_kind_of(Hq::PartnersController)
      expect_any_instance_of(Hq::PartnersController).to receive :authenticate_admin_user!
      get :foobar_action
    end
  end
end
