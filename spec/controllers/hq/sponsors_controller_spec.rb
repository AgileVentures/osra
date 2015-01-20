require 'rails_helper'

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
