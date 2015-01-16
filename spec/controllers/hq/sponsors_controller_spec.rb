require 'rails_helper'
class NoodlesController < Hq::SponsorsController; end

RSpec.describe Hq::SponsorsController, type: :controller do
  describe 'authentication' do
    controller NoodlesController do
      def foobar_action
        render nothing: true
      end
    end

    it 'checks for admin_user session' do
      routes.draw { get 'foobar_action', to: 'noodles#foobar_action' }
      expect(controller).to be_a_kind_of(Hq::SponsorsController)
      expect_any_instance_of(Hq::SponsorsController).to receive :authenticate_admin_user!
      get :foobar_action
    end
  end

end

RSpec.describe Hq::SponsorsController, type: :controller do
  before :each do
    sign_in instance_double(AdminUser)
    @sponsor = FactoryGirl.build_stubbed :sponsor
  end

  specify '#index' do
    expect(Sponsor).to receive(:all).and_return( [ @sponsor ] )
    get :index
    expect(response).to render_template 'index'
  end

end
