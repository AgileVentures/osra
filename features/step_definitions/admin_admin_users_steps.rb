Given(/^the following admin users exist:$/) do |table|
  table.hashes.each do |hash|
    partner = AdminUser.create!(email: hash[:email], 
                                password: hash[:password])
  end
end

Then(/^I should see "Admin Users" linking to the admin admin users page$/) do
  expect(page).to have_link("Admin Users", href: "#{admin_admin_users_path}")
end

Then(/^I should be on the "(.*?)" page for admin user "(.*?)"$/) do |page_name, user_email|
  admin_user = AdminUser.find_by email: user_email
  expect(current_path).to eq path_to(page_name, admin_user.id)
end

When(/^I (?:go to|am on) the "([^"]*)" page for admin user "([^"]*)"$/) do |page, user_email|
  user = AdminUser.find_by email: user_email
  visit path_to(page, user.id)
end


Then(/^I click on the Delete link for admin user "(.*?)"$/) do |user_email|
  user = AdminUser.find_by email: user_email
  scoped_css_id = "#admin_user_#{user.id}"
  within(scoped_css_id) do
    click_on "Delete"
  end
end

# only needed if we use webkit capybara driver
Then(/^I click ok on the confirmation box$/) do
  page.driver.accept_js_confirms!
end

