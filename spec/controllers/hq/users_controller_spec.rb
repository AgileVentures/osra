require 'rails_helper'

RSpec.describe Hq::UsersController, type: :controller do

  before :each do
    sign_in instance_double(AdminUser)
    @user = build_stubbed :user, email: 'someone@example.com'
  end

  it '#index' do
    expect(User).to receive(:all).and_return(@user)
    get :index
    expect(response).to render_template 'index'
  end

  specify '#show' do
    expect(User).to receive(:find).with('42').and_return(@user)
    get :show, id: 42
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
      new_user = controller.instance_variable_get(:@user)
      expect(new_user[:email]).to eq 'some email address'
      expect(flash[:success]).to be_nil
    end

    it 'handles valid updates' do
      allow(@old_user).to receive(:save).and_return(true)
      post :update, id: @old_user.id, user: { email: 'some email address'}
      expect(response).to redirect_to(hq_user_path(@old_user))
      expect(flash[:success]).to_not be_nil
    end

  end

end
