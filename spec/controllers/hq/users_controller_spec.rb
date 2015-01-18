require 'rails_helper'
class DummyusersController < Hq::UsersController; end

describe Hq::UsersController, type: :controller do
  describe 'authentication' do
    controller DummyusersController do
      def foobar_action
        render nothing: true
      end
    end

    it 'checks for admin_user session' do
      routes.draw { get 'foobar_action', to: 'dummyusers#foobar_action' }
      expect(controller).to be_a_kind_of(Hq::UsersController)
      expect_any_instance_of(Hq::UsersController).to receive :authenticate_admin_user!
      get :foobar_action
    end
  end
end
  
describe Hq::UsersController, type: :controller do

  before :each do
    sign_in instance_double(AdminUser)
    @user = build_stubbed :user
  end

  it '#index' do
    expect(User).to receive(:all).and_return(@user)
    get :index
    expect(response).to render_template 'index'
  end

end
