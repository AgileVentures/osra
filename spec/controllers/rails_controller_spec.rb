require 'rails_helper'

describe RailsController, type: :controller do
  controller do
    def index
      render inline: 'hello world'
    end
  end

  describe 'RSpec test' do
    example 'has an inherited anonymous controller' do
      expect(controller).to be_a_kind_of(RailsController)
    end
  end

  describe 'authentication' do
    it 'checks for admin_user session' do
      #allow(RailsController).to receive(:authenticate_admin_user!)
      expect_any_instance_of(RailsController).to receive :authenticate_admin_user!
      get :index
    end

    it 'allows a signed-in user through' do
      sign_in instance_double(AdminUser)
      #allow(RailsController).to receive(:authenticate_admin_user!).and_return instance_double(AdminUser)
      get :index
      expect(response.body).to match /hello world/
    end

    it 'rejects a signed-out user' do
      get :index
      expect(response.body).to_not match /hello world/
    end
  end
end
