require 'rails_helper'
require 'will_paginate/array'

RSpec.describe Hq::SponsorsController, type: :controller do
    let(:sponsorships_active) {(1..3).map {build_stubbed :sponsorship, active: true}}
    let(:sponsorships_inactive) {(1..2).map {build_stubbed :sponsorship, active: false}}
    let(:sponsor) {build_stubbed :sponsor, sponsorships: (sponsorships_active + sponsorships_inactive)}
    let(:sponsors) {(1..5).map {build_stubbed :sponsor}}

  before :each do
    sign_in instance_double(AdminUser)
  end

  specify '#index' do
    expect(Sponsor).to receive(:paginate).with(page: "2").
                  and_return( sponsors.paginate(per_page: 2) )
    get :index, page: 2
    expect(assigns(:sponsors).count).to eq 2
    expect(response).to render_template 'index'
  end

  specify '#show' do
    expect(Sponsor).to receive(:find).and_return(sponsor)
    get :show, id: sponsor.id
    expect(assigns(:sponsor)).to eq sponsor
    expect(assigns(:sponsorships_active)).to eq sponsorships_active
    expect(assigns(:sponsorships_inactive)).to eq sponsorships_inactive
    expect(response).to render_template 'show'
  end

  specify '#new' do
    sponsor_new = Sponsor.new
    expect(Sponsor).to receive(:new).and_return(sponsor_new)
    get :new
    expect(assigns(:sponsor)).to be_a_new(Sponsor)
    expect(response).to render_template 'new'
  end

  context '#create' do
    specify 'successful' do
      post :create, sponsor: build(:sponsor).attributes
      expect(response).to redirect_to hq_sponsor_url(assigns :sponsor)
    end

    specify 'redirects to new when user clicks Create and Add Another' do
      post :create, sponsor: build(:sponsor).attributes,
        commit: 'Create and Add Another'

      expect(response).to redirect_to new_hq_sponsor_path
    end

    specify 'unsuccessful' do
      expect_any_instance_of(Sponsor).to receive(:save).and_return(false)
      post :create, sponsor: build(:sponsor).attributes
      expect(response).to render_template 'new'
    end
  end

  specify '#edit' do
    expect(Sponsor).to receive(:find).and_return(sponsor)
    get :edit, id: sponsor.id
    expect(assigns(:sponsor)).to eq sponsor
    expect(response).to render_template 'edit'
  end

  context '#update' do
    specify 'successful' do
      expect(Sponsor).to receive(:find).and_return(sponsor)
      expect(sponsor).to receive(:save).and_return(true)
      put :update, id: sponsor.id, sponsor: sponsor.attributes
      expect(response).to redirect_to hq_sponsor_url(sponsor)
    end

    specify 'unsuccessful' do
      expect(Sponsor).to receive(:find).and_return(sponsor)
      expect(sponsor).to receive(:save).and_return(false)
      put :update, id: sponsor.id, sponsor: sponsor.attributes
      expect(response).to render_template 'edit'
    end
  end

end
