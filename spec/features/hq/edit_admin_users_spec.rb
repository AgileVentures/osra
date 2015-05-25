require 'rails_helper'

RSpec.feature 'Updating Admin Users', :type => :feature do

  scenario 'After resetting their password Admin Users should be able to log in with the new credentials' do
    i_sign_in_as_admin
    admin_user_to_reset = FactoryGirl.create :admin_user
    visit edit_hq_admin_user_path(admin_user_to_reset)
    fill_in 'Email', with: 'newadmin.user@example.com'
    fill_in 'New password', with: 'NewPassword'
    fill_in 'Password confirmation', with: 'NewPassword'
    click_button 'Update Admin User'
    i_sign_out
    i_sign_in_with_credentials('newadmin.user@example.com', 'NewPassword')
    and_i_should_see "Logged in successfully"
  end

end
