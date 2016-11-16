module FeatureHelpers
  module Authentication
    def i_sign_in_as_admin
      admin = FactoryGirl.create :admin_user
      visit new_admin_user_session_path
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_button 'Log in'
    end

    def i_sign_in_with_wrong_credentials
      visit new_admin_user_session_path
      fill_in 'Email', with: "none"
      fill_in 'Password', with: "none"
      click_button 'Log in'
    end

    def i_sign_in_with_credentials(usr, pwd)
      visit new_admin_user_session_path
      fill_in 'Email', with: usr
      fill_in 'Password', with: pwd
      click_button 'Log in'
    end

    def i_sign_out
      click_link 'logout'
    end
  end
end
