require 'rails_helper'
require 'will_paginate/array'

RSpec.describe Hq::OrphansController, type: :controller do
  let(:orphans) {build_stubbed_list(:orphan, 2)}
  let(:orphan) {build_stubbed :orphan}
  let(:orphan_statuses) {instance_double OrphanStatus}
  let(:orphan_sponsorship_statuses) {instance_double OrphanSponsorshipStatus}
  let(:provinces) {instance_double Province}

  before :each do
    sign_in instance_double(AdminUser)
  end

  specify '#index' do
    expect(Orphan).to receive(:paginate).with(page: "2")
      .and_return(orphans.paginate(per_page: 2, page: 1))
    get :index, page: "2"

    expect(assigns(:orphans)).to eq orphans
    expect(response).to render_template 'index'
  end

  specify '#show' do
    expect(Orphan).to receive(:find).with(orphan.id.to_s).and_return(orphan)
    get :show, id: orphan.id

    expect(assigns(:orphan)).to eq orphan
    expect(response).to render_template 'show'
  end

  context '#edit and #update' do
    before :each do
      expect(Orphan).to receive(:find).with(orphan.id.to_s).and_return(orphan)
    end

    specify 'editing renders the edit view' do
      expect(OrphanStatus).to receive(:all).and_return(orphan_statuses)
      expect(OrphanSponsorshipStatus).to receive(:all).and_return(orphan_sponsorship_statuses)
      expect(Province).to receive(:all).and_return(provinces)
      get :edit, id: orphan.id

      expect(assigns(:orphan)).to eq orphan
      expect(assigns(:orphan_statuses)).to eq orphan_statuses
      expect(assigns(:orphan_sponsorship_statuses)).to eq orphan_sponsorship_statuses
      expect(assigns(:provinces)).to eq provinces
      expect(response).to render_template 'edit'
    end

    specify 'successful update redirects to the show view' do
      expect(orphan).to receive(:save).and_return(true)
      patch :update, id: orphan.id, orphan: orphan.attributes

      expect(response).to redirect_to(hq_orphan_path(orphan))
      expect(flash[:success]).to_not be_nil
    end

    specify 'unsuccessful update renders the edit view' do
      expect(OrphanStatus).to receive(:all).and_return(orphan_statuses)
      expect(OrphanSponsorshipStatus).to receive(:all).and_return(orphan_sponsorship_statuses)
      expect(Province).to receive(:all).and_return(provinces)
      expect(orphan).to receive(:save).and_return(false)
      patch :update, id: orphan.id, orphan: orphan.attributes

      expect(assigns(:orphan)).to eq orphan
      expect(assigns(:orphan_statuses)).to eq orphan_statuses
      expect(assigns(:orphan_sponsorship_statuses)).to eq orphan_sponsorship_statuses
      expect(assigns(:provinces)).to eq provinces
      expect(response).to render_template 'edit'
      expect(flash[:success]).to be_nil
    end
  end
end
