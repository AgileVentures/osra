require 'rails_helper'
require 'will_paginate/array'

RSpec.describe 'admin_users/index.html.erb', type: :view do

  describe 'Admin User action items' do
    it 'should have a New Admin User link' do
      assign :admin_users, AdminUser.none.paginate(page: 1)

      render

      expect(rendered).to have_link 'New Admin User', new_admin_user_path
    end
  end

  describe 'pagination' do
    it 'should paginate' do
      assign :admin_users, AdminUser.none.paginate(page: 1)
      expect(view).to receive(:will_paginate)

      render
    end
  end

  describe 'admin user display' do
    let(:admin_user) { build_stubbed :admin_user }

    before(:each) do
      assign :admin_users, [admin_user].paginate(page: 1)
    end

    it 'should render user info' do
      allow(view).to receive(:current_admin_user).and_return(nil)

      render

      expect(rendered).to match admin_user.email
    end

    describe 'instance action links' do
      it 'should render Edit' do
        allow(view).to receive(:current_admin_user).and_return(nil)

        render

        expect(rendered).to have_link 'Edit',
          edit_admin_user_path(admin_user)
      end

      it 'should render Delete for non-signed-in admin users' do
        allow(view).to receive(:current_admin_user).and_return(nil)

        render

        expect(rendered).to have_link 'Delete',
          admin_user_path(admin_user)
      end

      it 'should not render Delete for signed-in admin user' do
        allow(view).to receive(:current_admin_user).and_return(admin_user)

        render

        expect(rendered).not_to have_link 'Delete',
          admin_user_path(admin_user)
      end
    end
  end
end
