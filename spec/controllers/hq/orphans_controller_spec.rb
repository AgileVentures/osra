require 'rails_helper'
require 'will_paginate/array'

RSpec.describe Hq::OrphansController, type: :controller do
  let(:orphan) {build_stubbed :orphan}

  before :each do
    sign_in instance_double(AdminUser)
  end

  specify '#show' do
    expect(Orphan).to receive(:find).and_return(orphan)

    get :show, id: orphan.id

    expect(assigns(:orphan)).to eq orphan
    expect(response).to render_template 'show'
  end

  context '#edit and #update' do
    before :each do
      expect(Orphan).to receive(:find).and_return(orphan)
    end

    specify 'editing renders the edit view' do
      get :edit, id: orphan.id
      expect(response).to render_template 'edit'
    end

    specify 'unsuccessful update renders the edit view' do
      expect(orphan).to receive(:save).and_return(false)
      patch :update, id: orphan.id, orphan: orphan.attributes
      expect(response).to render_template 'edit'
    end

    specify 'successful update redirects to the show view' do
      expect(orphan).to receive(:save).and_return(true)
      patch :update, id: orphan.id, orphan: orphan.attributes
      expect(response).to redirect_to(hq_orphan_path(orphan))
    end
  end

  context '#index' do
    specify 'pagination' do
      expect(Orphan).to receive(:paginate).with(page: "2").and_return([].paginate)
      get :index, page: "2"
    end
  end
end
