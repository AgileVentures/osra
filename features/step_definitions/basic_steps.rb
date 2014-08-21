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

def path_to(page_name, id = '')
  name = page_name.downcase
  case name
    when 'admin partners' then
      admin_partners_path
    when 'admin partners show' then
      admin_partner_path(id)
    when 'admin partners edit' then
      edit_admin_partner_path(id)
    else
      raise('path to specified is not listed in #path_to')
  end
end

When(/^I (?:go to|am on) the "([^"]*)" page$/) do |page|
  visit path_to(page)
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

