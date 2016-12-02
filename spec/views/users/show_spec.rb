require 'rails_helper'
require 'cgi'

RSpec.describe 'users/show.html.erb', type: :view do
  describe 'user' do
    let(:user) { FactoryGirl.build_stubbed :user }

    before :each do
      assign :user, user
      assign :inactive_sponsors, []
      assign :active_sponsors, []
      render
    end

    describe 'displays' do
      specify 'user name' do
        expect(rendered).to match CGI::escape_html(user.user_name)
      end

      specify 'email address' do
        expect(rendered).to match CGI::escape_html(user.email)
      end

      specify 'Edit User button' do
        expect(rendered).to have_link 'Edit User', edit_user_path(user)
      end
    end
  end

 end

