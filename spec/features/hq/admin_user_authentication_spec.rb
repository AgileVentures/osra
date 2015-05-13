require 'rails_helper'

RSpec.feature 'AdminUser authentication', :type => :feature do

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
    and_i_should_see "Invalid email or password"
  end

  def and_i_should_not_have_access_to_restricted_application_pages
    visit hq_root_path
    expect(current_path).to eq new_hq_admin_user_session_path
  end
end
