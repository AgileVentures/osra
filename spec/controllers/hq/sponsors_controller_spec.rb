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

  specify '#show' do
    expect(Sponsor).to receive(:find).and_return(@sponsor)
    get :show, id: @sponsor.id
    expect(assigns(:sponsor)).to eq @sponsor
    expect(response).to render_template 'show'
  end
  
  specify '#edit' do
    expect(Sponsor).to receive(:find).and_return(@sponsor)
    get :edit, id: @sponsor.id
    expect(assigns(:sponsor)).to eq @sponsor
    expect(response).to render_template 'edit'
  end

  context '#update' do
    specify 'successful' do
      expect(Sponsor).to receive(:find).and_return(@sponsor)
      expect(@sponsor).to receive(:save).and_return(true)
      put :update, id: @sponsor.id, sponsor: @sponsor.attributes
      expect(response).to redirect_to hq_sponsor_url(@sponsor)
    end

    specify 'unsuccessful' do
      expect(Sponsor).to receive(:find).and_return(@sponsor)
      expect(@sponsor).to receive(:save).and_return(false)
      put :update, id: @sponsor.id, sponsor: @sponsor.attributes
      expect(response).to render_template 'edit'
    end
  end
  
end
