require 'rails_helper'

class NyuksController < ApplicationController; end

RSpec.describe ApplicationController, type: :controller do
  controller NyuksController do
    def foobar_action
      render nothing: true
    end
  end

  describe 'controllers inheriting from ApplicationController' do
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
      expect(ApplicationController::NAVIGATION_BUTTONS).to be_present
      expect(ApplicationController::NAVIGATION_BUTTONS).to be_a_kind_of Array
    end
  end
end
