require 'rails_helper'
require 'will_paginate/array'

describe "hq/users/index.html.erb", type: :view do

  context 'class action-items' do
    it 'should have a New User link' do
      assign(:users, [].paginate)
      render
      expect(rendered).to have_link('New User', new_hq_user_path)
    end
  end

  describe 'should display users correctly' do
    context 'no users' do
      it 'hides the table' do
        @users = [].paginate
        render

        expect(rendered).to match /No Users Found/
        assert_select 'table#users-index', count: 0
      end
    end

    context '1 user' do
      it 'displays a single user' do
        @users = [ FactoryGirl.build_stubbed(:user, user_name: 'Frederick Bloggs',
          email: 'fred.bloggs@example.com') ].paginate
        render

        expect(rendered).to have_selector('table tr', count: 2)
        expect(rendered).to have_link('Frederick Bloggs', href: hq_user_path(@users[0]))
        expect(rendered).to match 'fred.bloggs@example.com'
      end
    end

    context '>1 user' do
      before :each do
        @users= [ FactoryGirl.build_stubbed(:user, user_name: 'Frederick Bloggs',
                  email: 'fred.bloggs@example.com'),
                  FactoryGirl.build_stubbed(:user, user_name: 'Joseph Soap',
                  email: 'joe.soap@example.com') ].paginate(:page => 1, :per_page => 2)
      end

      it 'displays multiple users' do
        render
        expect(rendered).to have_selector('table tr', count: 3)
        expect(rendered).to have_link('Frederick Bloggs', href: hq_user_path(@users[0]))
        expect(rendered).to match 'fred.bloggs@example.com'
        expect(rendered).to have_link('Joseph Soap', href: hq_user_path(@users[1]))
        expect(rendered).to match 'joe.soap@example.com'
      end

      it 'paginates' do
        expect(view).to receive(:will_paginate)

        render
      end
    end
  end
end
