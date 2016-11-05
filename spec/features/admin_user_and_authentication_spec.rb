require 'rails_helper'

RSpec.feature 'AdminUser', :type => :feature do

  scenario 'Restricted pages should be accessible to logged in users' do
    i_sign_in_as_admin
    and_i_should_be_on :root_page
  end

  scenario 'Restricted pages should not be accessible to logged out users' do
    i_sign_in_as_admin
    i_sign_out
    and_i_should_be_on :sign_in_page
    and_i_should_not_have_access_to_restricted_application_pages
  end

  scenario 'Logging in only possible with correct credentials' do
    i_sign_in_with_wrong_credentials
    and_i_should_be_on :sign_in_page
    and_i_should_see 'Invalid email or password'
  end

  scenario 'After creation new Admin Users should be able to log in' do
    i_sign_in_as_admin
    visit admin_users_path
    click_link 'New'
    fill_in 'Email', with: 'newadmin.user@example.com'
    fill_in 'Password', with: 'Password'
    fill_in 'Password confirmation', with: 'Password'
    click_button 'Create Admin User'
    i_sign_out
    i_sign_in_with_credentials('newadmin.user@example.com', 'Password')
    and_i_should_see 'Logged in successfully'
  end

  scenario 'After resetting their password Admin Users should be able to log in with the new credentials' do
    i_sign_in_as_admin
    visit admin_users_path
    click_link 'Edit'
    fill_in 'Email', with: 'newadmin.user@example.com'
    fill_in 'New password', with: 'NewPassword'
    fill_in 'Password confirmation', with: 'NewPassword'
    click_button 'Update Admin User'
    i_sign_out
    i_sign_in_with_credentials('newadmin.user@example.com', 'NewPassword')
    and_i_should_see 'Logged in successfully'
  end

  scenario 'I should not see a delete link for current_user' do
    i_sign_in_as_admin
    visit admin_users_path
    and_i_should_not_see 'Delete'
  end

  scenario 'I should see a delete link for other admin_user' do
    i_sign_in_as_admin
    visit admin_users_path
    and_i_should_not_see 'Delete'
    click_link 'New'
    fill_in 'Email', with: 'newadmin.user@example.com'
    fill_in 'Password', with: 'Password'
    fill_in 'Password confirmation', with: 'Password'
    click_button 'Create Admin User'
    and_i_should_see 'Delete'
  end

  scenario 'Should be able to delete another admin user' do
    i_sign_in_as_admin
    visit admin_users_path
    click_link 'New'
    fill_in 'Email', with: 'newadmin.user@example.com'
    fill_in 'Password', with: 'Password'
    fill_in 'Password confirmation', with: 'Password'
    click_button 'Create Admin User'
    click_on 'Delete'
    and_i_should_be_on :admin_users_page
    and_i_should_not_see 'newadmin.user@example.com'
  end

  def and_i_should_not_have_access_to_restricted_application_pages
    visit root_path
    expect(current_path).to eq new_admin_user_session_path
  end

end
