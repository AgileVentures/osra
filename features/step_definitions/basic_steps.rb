Given(/^I am on the admin dashboard page$/) do
  visit admin_root_path
end

Given /^I am a new, authenticated user$/ do
  email = 'testing@man.net'
  password = 'secretpass'
  AdminUser.new(:email => email, :password => password, :password_confirmation => password).save!

  visit new_admin_user_session_path
  fill_in "admin_user_email", :with => email
  fill_in "admin_user_password", :with => password
  click_button "Login"
end

def path_to_admin_role(page_name, id = '')
  name = page_name.downcase
  case name
    when 'partners' then
      admin_partners_path
    when 'new partners' then
      new_admin_partner_path
    when 'show partners' then
      admin_partner_path(id)
    when 'edit partners' then
      edit_admin_partner_path(id)
    when 'admin users' then
      admin_admin_users_path
    when 'new admin user' then
      new_admin_admin_user_path
    when 'show admin users' then
      admin_admin_user_path(id)
    when 'edit admin users' then
      edit_admin_admin_user_path(id)
    else
      raise('path to specified is not listed in #path_to')
  end
end

When(/^I (?:go to|am on) the "([^"]*)" page for the "([^"]*)" role$/) do  |page, role|
  case role.downcase
  when "admin"
    visit path_to_admin_role(page)
  else
    raise "role not covered in this method"
  end
end

Then(/^I should be on the "(.*?)" page for the "([^"]*)" role$/) do |page_name, role|
  case role.downcase
  when "admin"
    expect(current_path).to eq path_to_admin_role(page_name)
  else 
    raise "role not covered in this method"
  end
end

Then /^I should( not)? see "([^"]*)"$/ do |negative, string|
  unless negative
    expect(page).to have_text string
  else
    expect(page).not_to have_text string
  end
end

Then /^I should( not)? see the "([^"]*)" link$/ do |negative, button|
  unless negative
    expect(page).to have_link button
  else
    expect(page).not_to have_link button
  end
end


When(/^I click the "([^"]*)" link$/) do |link|
  click_link link
end

When(/^I click the "([^"]*)" button$/) do |button|
  click_link_or_button button
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in field, :with => value
end

Given(/^I select "(.*?)" from the drop down box for "(.*?)"$/) do |choice, name|
  page.select(choice, from: name)
end

