require 'rails_helper'
class NyuksController < HqController; end

RSpec.describe HqController, type: :controller do
  controller NyuksController do
    def foobar_action
      render nothing: true
    end
  end

  before :each do
    routes.draw do
      get 'foobar_action', to: 'nyuks#foobar_action'
    end
  end

  describe 'authentication' do
    it 'checks for admin_user session' do
      expect(NyuksController.superclass).to eq HqController
      expect_any_instance_of(HqController).to receive :authenticate_admin_user!
      get :foobar_action
    end
  end
end
