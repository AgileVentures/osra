require 'rails_helper'

RSpec.describe Hq::SponsorsController, type: :controller do
  before :each do
    sign_in instance_double(AdminUser)
    @sponsor = FactoryGirl.build_stubbed :sponsor
    @sponsor_build = FactoryGirl.build :sponsor
    @sponsor_new = Sponsor.new
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

  specify '#new' do
    expect(Sponsor).to receive(:new).and_return(@sponsor_new)
    get :new
    expect(assigns(:sponsor)).to be_a_new(Sponsor)
    expect(response).to render_template 'new'
  end

  context '#create' do
    specify 'successful' do
      expect(Sponsor).to receive(:new).and_return(@sponsor_new)
      expect {post :create, sponsor: @sponsor_build.attributes }.to change{Sponsor.count}.by 1
      expect(response).to redirect_to hq_sponsor_url(Sponsor.find_by_name(@sponsor_build.name))
    end

    specify 'unsuccessful' do
      expect(Sponsor).to receive(:new).and_return(@sponsor_new)
      expect_any_instance_of(Sponsor).to receive(:save).and_return(false)
      expect {post :create, sponsor: @sponsor_build.attributes }.to change{Sponsor.count}.by 0
      expect(response).to render_template 'new'
    end
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
