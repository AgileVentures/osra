require 'rails_helper'

RSpec.feature 'AdminUser authentication', :type => :feature do

  scenario 'Restricted pages should be accessible to logged in users' do
    i_sign_in_as_admin
    and_i_should_be_on_root_page
  end

  scenario 'Restricted pages should not be accessible to logged out users' do
    i_sign_in_as_admin
    i_sign_out
    and_i_should_be_on_new_admin_user_session_page
    and_i_should_not_have_access_to_application
  end
end

def i_sign_in_as_admin
  admin = FactoryGirl.create :admin_user
  visit new_hq_admin_user_session_path
  fill_in 'Email', with: admin.email
  fill_in 'Password', with: admin.password
  click_button 'Log in'
end

def i_sign_out
  click_link 'logout'
end

def and_i_should_be_on_root_page
  expect(current_path).to eq hq_root_path
end

def and_i_should_be_on_new_admin_user_session_page
  expect(current_path).to eq new_hq_admin_user_session_path
end

def and_i_should_not_have_access_to_application
  visit hq_root_path
  expect(current_path).to eq new_hq_admin_user_session_path
end