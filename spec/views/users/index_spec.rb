require 'rails_helper'

describe "users/index.html.erb", type: :view do

  context 'User action-items' do
    it 'should have a New User link' do
      assign(:users, User.none.paginate(:page => 1))
      render

      expect(rendered).to have_link('New User', new_user_path)
    end

    it 'should have a pagination bar' do
      assign(:users, build_stubbed_list(:user,1))
      expect(view).to receive(:will_paginate)
      render
    end
  end

  describe 'should display users correctly' do
    context 'for no users' do
      before(:each) do
        @users = User.none.paginate(:page => 1)
        render
      end

      it 'hides the table' do
        expect(rendered).to match /No Users Found/
        expect(rendered).to have_selector('table#users-index', count: 0)
      end
    end

    context 'for multiple users' do
      before :each do
        @users= build_stubbed_list(:user, 2).paginate(:page => 1)
      end

      it 'shows the table' do
        render

        expect(rendered).to_not match /No Users Found/
        expect(rendered).to have_selector('table tbody tr', count: 2)
      end

      it 'shows user names as link' do
        render

        expect(rendered).to have_link(@users.first.user_name, href: user_path(@users.first))
      end
    end
  end
end
