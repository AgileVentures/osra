require 'rails_helper'
require 'will_paginate/array'

RSpec.describe Hq::AdminUsersController, type: :controller do
  let(:admin_users) { build_stubbed_list :admin_user, 2 }
  let(:admin_user) { build_stubbed :admin_user }

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

  specify '#new' do
    get :new
    expect(response).to render_template 'new'
    expect(assigns(:admin_user)).to be_a_new(AdminUser)
  end

  describe '#create' do

    before :each do
      allow(AdminUser).to receive(:new).and_return(admin_user)
    end

    specify 'successful create shows the new user on index page' do
      expect(admin_user).to receive(:save).and_return(true)
      post :create, admin_user: { email: 'some email address' }
      expect(response).to redirect_to hq_admin_users_path
      expect(flash[:success]).to_not be_nil
    end

    specify 'unsuccessful create re-renders the New Admin User view' do
      expect(admin_user).to receive(:save).and_return(false)
      post :create, admin_user: { email: 'some email address' }
      expect(response).to render_template 'new'
    end

  end

end
