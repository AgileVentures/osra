require 'rails_helper'
require 'will_paginate/array'

RSpec.describe Hq::AdminUsersController, type: :controller do
  let(:admin_users) { build_stubbed_list :admin_user, 2 }

  before(:each) do
    sign_in instance_double(AdminUser)
  end

  specify '#index' do
    allow(AdminUser).to receive(:paginate).with(page: '1').
      and_return(admin_users.paginate(per_page: 2, page: 1))

    get :index, page: 1

    expect(assigns(:admin_users)).to eq admin_users
    expect(response).to render_template 'index'
  end
end
