require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:users) { build_stubbed_list(:user, 3) }

  before :each do
    sign_in instance_double(AdminUser)
    @user = build_stubbed :user
  end

  specify '#index' do
    expect(User).to receive(:paginate).with(page: '2').
                    and_return( users.paginate(per_page: 2, page: 2) )
    get :index, page: '2'
    expect(assigns(:users).count).to eq 1
    expect(response).to render_template 'index'
  end

  specify '#show' do
    expect(User).to receive(:find).with('42').and_return(@user)
    get :show, id: 42
    expect(assigns(:user)).to eq @user
    expect(response).to render_template 'show'
  end

  describe '#edit and #update' do
    before :each do
      @old_user = FactoryGirl.build_stubbed(:user)
      expect(User).to receive(:find).and_return(@old_user)
    end

    specify 'editing renders the edit view' do
      get :edit, id: @old_user.id
      expect(response).to render_template 'edit'
    end

    it 'handles invalid updates' do
      allow(@old_user).to receive(:save).and_return(false)
      post :update, id: @old_user.id, user: { email: 'some email address'}
      expect(response).to render_template 'edit'
      expect(flash[:success]).to be_nil
    end

    it 'handles valid updates' do
      allow(@old_user).to receive(:save).and_return(true)
      post :update, id: @old_user.id, user: { email: 'some email address'}
      expect(response).to redirect_to(user_path(@old_user))
      expect(flash[:success]).to_not be_nil
    end

  end

  describe '#new' do

    before :each do
      @new_user = User.new
      allow(User).to receive(:new).and_return(@new_user)
    end

    it 'enables entering details of a new user' do
      get :new
      expect(response).to render_template 'new'
      expect(assigns(:user)).to be_a_new(User)
    end

  end

  describe '#create' do

    before :each do
      @new_user = FactoryGirl.build_stubbed(:user, user_name: nil, email: nil)
      allow(User).to receive(:new).and_return(@new_user)
    end

    specify 'successful create shows the new user' do
      expect(@new_user).to receive(:save).and_return(true)
      post :create, user: { user_name: 'some user' }
      expect(response).to redirect_to user_path(@new_user)
      expect(flash[:success]).to_not be_nil
    end

    specify 'unsuccessful create re-renders the new view' do
      expect(@new_user).to receive(:save).and_return(false)
      post :create, user: { user_name: 'some user' }
      expect(response).to render_template 'new'
    end

  end

end
