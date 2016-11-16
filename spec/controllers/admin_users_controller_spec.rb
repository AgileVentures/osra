require 'rails_helper'
require 'will_paginate/array'

RSpec.describe AdminUsersController, type: :controller do

# The include statement below is necessary for the unit tests to work when rspec runs the complete test run
# Otherwise the inclusion of integration tests which use Devise mucks things up.
# See https://github.com/plataformatec/devise/wiki/How-To:-Test-controllers-with-Rails-3-and-4-%28and-RSpec%29
  include Devise::TestHelpers

  let(:admin_users) { build_stubbed_list :admin_user, 2 }
  let(:admin_user) { build_stubbed :admin_user }

  before(:each) do
    user = instance_double(AdminUser)
    sign_in user
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
      expect(response).to redirect_to admin_users_path
      expect(flash[:success]).to_not be_nil
    end

    specify 'unsuccessful create re-renders the New Admin User view' do
      expect(admin_user).to receive(:save).and_return(false)
      post :create, admin_user: { email: 'some email address' }
      expect(response).to render_template 'new'
    end

  end

  describe '#edit and #update' do

  before(:each) do
    allow(AdminUser).to receive(:find).and_return(admin_user)
    allow(controller).to receive(:current_admin_user).and_return(admin_user)
    @request.env["devise.mapping"] = Devise.mappings[:admin_user]
  end

    specify 'editing renders the edit view' do
      get :edit, id: admin_user.id
      expect(response).to render_template 'edit'
    end

    it 'handles invalid updates' do
      allow(admin_user).to receive(:save).and_return(false)
      post :update, id: admin_user.id, admin_user: { email: 'some email address'}
      expect(response).to render_template 'edit'
      expect(flash[:success]).to be_nil
    end

    it 'handles valid updates' do
      allow(AdminUser).to receive(:find).and_return(admin_user)
      allow(admin_user).to receive(:save).and_return(true)
      post :update, id: admin_user.id, admin_user: { email: 'some email address'}
      expect(response).to redirect_to(admin_users_path)
      expect(flash[:success]).to_not be_nil
    end

  end

  describe '#destroy' do

    specify 'should redirect to the index page' do
      allow(AdminUser).to receive(:find).and_return(admin_user)
      expect(admin_user).to receive(:destroy).and_return(true)
      delete :destroy, id: admin_user.id
      expect(flash[:success]).to_not be_nil
      expect(response).to redirect_to(admin_users_path)
    end

  end

end
