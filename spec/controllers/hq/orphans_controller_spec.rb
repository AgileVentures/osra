require 'rails_helper'
require 'will_paginate/array'

RSpec.describe Hq::OrphansController, type: :controller do
  before :each do
    sign_in instance_double(AdminUser)
  end

  context 'new and #create' do
    let(:orphan) { build_stubbed :orphan }

    before :each do
      controller.instance_variable_set(:@orphan, orphan)
    end

    specify 'successful create redirects to the show view' do
      expect(orphan).to receive(:save).and_return(true)
      post :create, orphan: orphan.attributes
      expect(response).to redirect_to hq_orphan_path(orphan)
    end

    # specify 'unsuccessful create renders the new view' do
    #   expect(orphan).to receive(:save).and_return(false)
    #   post :create, orphan: orphan.attributes
    #   expect(response).to render_template 'new'
    # end
  end

  # context '#edit and #update' do
  #   before :each do
  #     @orphan = build_stubbed :orphan
  #     expect(Orphan).to receive(:find).and_return(@orphan)
  #   end
  #
  #   specify 'editing renders the edit view' do
  #     get :edit, id: @orphan.id
  #     expect(response).to render_template 'edit'
  #   end
  #
  #   specify 'unsuccessful update renders the edit view' do
  #     expect(@orphan).to receive(:save).and_return(false)
  #     patch :update, id: @orphan.id, orphan: @orphan.attributes
  #     expect(response).to render_template 'edit'
  #   end
  #
  #   specify 'successful update redirects to the show view' do
  #     expect(@orphan).to receive(:save).and_return(true)
  #     patch :update, id: @orphan.id, orphan: @orphan.attributes
  #     expect(response).to redirect_to(hq_orphan_path(@orphan))
  #   end
  # end
  #
  context '#index' do
    specify 'pagination' do
      expect(Orphan).to receive(:paginate).with(page: "2").and_return([].paginate)
      get :index, page: "2"
    end
  end
end
