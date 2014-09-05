Given(/^the following admin users exist:$/) do |table|
  table.hashes.each do |hash|
    partner = AdminUser.create!(hash)
  end
end

Then(/^I should see "Admin Users" linking to the admin admin users page$/) do
  expect(page).to have_link("Admin Users", href: "#{admin_admin_users_path}")
end

Then(/^I should be on the "(.*?)" page for admin user "(.*?)"$/) do |page_name, user_email|
  admin_user = AdminUser.find_by email: user_email
  expect(current_path).to eq path_to_admin_role(page_name, admin_user.id)
end

When(/^I (?:go to|am on) the "([^"]*)" page for admin user "([^"]*)"$/) do |page, user_email|
  user = AdminUser.find_by email: user_email
  visit path_to_admin_role(page, user.id)
end


Then(/^I accept the Delete link for admin user "(.*?)"$/) do |user_email|
  user = AdminUser.find_by email: user_email
  scoped_css_id = "#admin_user_#{user.id}"
  within(scoped_css_id) do
    if Capybara.current_driver == :webkit
      page.accept_confirm do
        click_on "Delete"
      end
    elsif Capybara.current_driver == :poltergeist
      click_on "Delete"
    else
      raise "You need to write a path for javascript driver #{Capybara.current_driver}"
    end
  end
end

Then(/^I do not accept the Delete link for admin user "(.*?)"$/) do |user_email|
  user = AdminUser.find_by email: user_email
  scoped_css_id = "#admin_user_#{user.id}"
  within(scoped_css_id) do
    if Capybara.current_driver == :webkit
      page.dismiss_confirm do
        click_on "Delete"
      end
    elsif Capybara.current_driver == :poltergeist
      raise "You cannot check the dismissal of a dialog box with the poltergeist driver"
    else
      raise "You need to write a path for javascript driver #{Capybara.current_driver}"
    end
  end
end
