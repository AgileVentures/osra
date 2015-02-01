require 'rails_helper'

class NyuksController < HqController; end

RSpec.describe HqController, type: :controller do
  describe 'owns namespace controllers' do
    Rails.application.eager_load!
    ApplicationController.descendants.each do |_controller|
      if _controller.to_s.include? 'Hq::'
        specify "HqController is the parent of #{_controller.to_s}" do
          expect(_controller.superclass).to eq HqController
        end
      end
    end
  end

  controller NyuksController do
    def foobar_action
      render nothing: true
    end
  end

  describe 'controllers inheriting from HqController' do
    specify 'check for authentication' do
      routes.draw do
        get 'foobar_action', to: 'nyuks#foobar_action'
      end
      expect_any_instance_of(Devise::Controllers::Helpers).to receive :authenticate_admin_user!

      get :foobar_action
    end
  end

  describe 'instantiates' do
    specify 'navigation buttons' do
      expect(HqController::NAVIGATION_BUTTONS).to be_present.and be_a_kind_of Hash
    end
  end

end
