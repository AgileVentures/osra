require 'rails_helper'
require 'will_paginate/array'

RSpec.describe Hq::OrphansController, type: :controller do
  let(:orphans) {build_stubbed_list(:orphan, 2)}
  let(:orphan) {build_stubbed :orphan}
  let(:statuses) { [] }
  let(:sponsorship_statuses) { [] }
  let(:provinces) {instance_double Province}

  before :each do
    sign_in instance_double(AdminUser)
  end

  specify '#index with pagination' do
    expect(Orphan).to receive(:paginate).with(page: "2")
      .and_return(orphans.paginate(per_page: 3, page: 1))
    get :index, page: "2"

    expect(assigns(:orphans)).to eq orphans
    expect(response).to render_template 'index'
  end

  context '#index with sorting' do


    let(:orphans_for_sorting) { FactoryGirl.create_list(:orphan, 3) }
    let(:orphans_sorted_by_name_asc) { orphans_for_sorting.sort{|o1, o2| o1.name <=> o2.name} }

    specify 'ascending' do

      get :index, page: "1", sort_by: "name", direction: "asc"

      expect(assigns(:orphans)).to eq orphans_sorted_by_name_asc
    end

    specify 'descending' do

      get :index, page: "1", sort_by: "date_of_birth", direction: "desc"

      expect(assigns(:orphans)).to eq orphans_for_sorting.sort{|o1, o2| o1.date_of_birth <=> o2.date_of_birth}.reverse
    end

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
      expect(Orphan).to receive_message_chain(:statuses, :keys, :map).
        and_return(statuses)
      expect(Orphan).to receive_message_chain(:sponsorship_statuses, :keys, :map).
        and_return(sponsorship_statuses)
      expect(Province).to receive(:all).and_return(provinces)
      get :edit, id: orphan.id

      expect(assigns(:orphan)).to eq orphan
      expect(assigns(:statuses)).to eq statuses
      expect(assigns(:sponsorship_statuses)).to eq sponsorship_statuses
      expect(assigns(:provinces)).to eq provinces
      expect(response).to render_template 'edit'
    end

    specify 'successful update redirects to the show view' do
      expect(orphan).to receive(:save).and_return(true)
      patch :update, id: orphan.id, orphan: { name: 'John' }

      expect(response).to redirect_to(hq_orphan_path(orphan))
      expect(flash[:success]).to_not be_nil
    end

    specify 'unsuccessful update renders the edit view' do
      expect(Orphan).to receive_message_chain(:statuses, :keys, :map).
        and_return(statuses)
      expect(Orphan).to receive_message_chain(:sponsorship_statuses, :keys, :map).
        and_return(sponsorship_statuses)
      expect(Province).to receive(:all).and_return(provinces)
      expect(orphan).to receive(:save).and_return(false)
      patch :update, id: orphan.id, orphan: { name: 'John' }

      expect(assigns(:orphan)).to eq orphan
      expect(assigns(:statuses)).to eq statuses
      expect(assigns(:sponsorship_statuses)).to eq sponsorship_statuses
      expect(assigns(:provinces)).to eq provinces
      expect(response).to render_template 'edit'
      expect(flash[:success]).to be_nil
    end
  end
end
