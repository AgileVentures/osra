require 'rails_helper'

describe "layouts/_header.html.erb", type: :view do

  describe 'while logged-in' do
    let :admin_user do
      AdminUser.create(email: 'example@server.com', password: 'password',
                        password_confirmation: 'password')
    end
    before :each do
      assign(:user, admin_user)
    end

    describe 'header buttons' do
      specify 'are all visible' do
        render and eval %Q{
          expect(rendered).to match /#{RailsController::HEADER_BUTTONS * "(.+)"}/im
        }
      end

      context 'when no model is given' do
        specify 'no buttons are highlighted' do
          render and expect(rendered).to_not match /<li([^>]*)class="current"([^>]*)>/m
        end
      end

      context 'when a model is given' do
        before :each do
          assign(:model, Partner)
        end

        specify 'it is highlighted' do
          render and expect(rendered).to match /<li([^>]*)class="current"([^>]*)id="partners"([^>]*)>/m
        end

        specify 'only one button is highlighted' do
          render and expect(rendered).to_not match /<li([^>]*)class="current"([^>]*)>(.*)<li([^>]*)class="current"([^>]*)>/m
        end
      end
    end

    describe 'user' do
      specify 'should have a logout button' do
        render and expect(rendered).to match /Logout/
      end

      it 'should show the current user' do
        render and expect(rendered).to match admin_user.to_s
      end
    end
  end

  describe 'while logged-out' do
    specify do
      expect{render}.to raise_error
      #require an http 500 Internal Server Error
    end
  end
end
