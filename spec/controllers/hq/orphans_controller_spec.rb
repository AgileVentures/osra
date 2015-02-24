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
end
