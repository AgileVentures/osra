Given(/^the following users exist:$/) do |table|
  table.hashes.each do |hash|
    User.create!(hash)
  end
end

Then(/^I should see "([^"]*)" linking to the admin (.*) index page$/) do |link_text, link_path|
  path = "admin_#{link_path.gsub(' ', '_')}_path"
  expect(page).to have_link(link_text, href: eval(path))
end

Then /^I should be on the "([^"]*)" page for user "([^"]*)"$/ do |page, user_name|
  user_id = User.find_by_user_name(user_name).id
  expect(current_path).to eq path_to_admin_role(page, user_id)
end

When(/^I (?:go to|am on) the "([^"]*)" page for user "([^"]*)"$/) do |page, user_name|
  user_id = User.find_by_user_name(user_name).id
  visit path_to_admin_role(page, user_id)
end

Given /^a user "([^"]*)" exists$/ do |user_name|
  FactoryGirl.create :user, user_name: user_name
end
