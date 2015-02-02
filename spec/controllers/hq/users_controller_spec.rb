require 'rails_helper'

RSpec.describe Hq::UsersController, type: :controller do

  before :each do
    sign_in instance_double(AdminUser)
    @user = build_stubbed :user
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
end
