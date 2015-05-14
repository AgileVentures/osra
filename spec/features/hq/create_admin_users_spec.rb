require 'rails_helper'

RSpec.feature 'Creating Admin Users', :type => :feature do

  scenario 'After creation new Admin Users should be able to log in' do
    i_sign_in_as_admin
    visit new_hq_admin_user_path
    fill_in 'Email', with: 'newadmin.user@example.com'
    fill_in 'Password', with: 'Password'
    fill_in 'Password confirmation', with: 'Password'
    click_button 'Create Admin User'
    i_sign_out
    i_sign_in_with_credentials('newadmin.user@example.com', 'Password')
    and_i_should_see "Logged in successfully"
  end

end
