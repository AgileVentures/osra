Given(/^I am on the admin dashboard page$/) do
  visit admin_root_path
end

Given /^I am a new, authenticated user$/ do
  email = 'testing@man.net'
  password = 'secretpass'
  AdminUser.new(email: email, password: password, password_confirmation: password).save!

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
    when 'new partner' then
      new_admin_partner_path
    when 'show partner' then
      admin_partner_path(id)
    when 'edit partner' then
      edit_admin_partner_path(id)
    when 'sponsors' then
      admin_sponsors_path
    when 'new sponsor' then
      new_admin_sponsor_path
    when 'show sponsor' then
      admin_sponsor_path(id)
    when 'edit sponsor' then
      edit_admin_sponsor_path(id)
    when 'admin users' then
      admin_admin_users_path
    when 'new admin user' then
      new_admin_admin_user_path
    when 'show admin user' then
      admin_admin_user_path(id)
    when 'edit admin user' then
      edit_admin_admin_user_path(id)
    when 'orphans'
      admin_orphans_path
    when 'show orphans'
      admin_orphan_path(id)
    when 'edit orphans'
      edit_admin_orphan_path(id)
    when 'organizations' then
      admin_organizations_path
    when 'show organization' then
      admin_organization_path(id)
    when 'edit organization' then
      edit_admin_organization_path(id)
    when 'new organization' then
      new_admin_organization_path
    when 'link to orphan' then
      new_admin_sponsor_sponsorship_path(id)
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

Then(/^I should be on the "([^"]*)" page for the "([^"]*)" role$/) do |page_name, role|
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
  fill_in field, with: value
end

Given(/^I select "([^"]*)" from the drop down box for "([^"]*)"$/) do |choice, name|
  page.select(choice, from: name)
end

Then(/^I should see the following fields on the page:$/) do |table|
  table.hashes.each do |hash|
    expect(page).to have_content(hash[:value])
  end
end

Then(/^I (un)?check the "([^"]*)" checkbox$/) do |negative,checkbox|
  negative ? uncheck(checkbox) : check(checkbox)
end

Then(/^I should see "([^"]*)" set to "([^"]*)"$/) do |label, value|
  expect(find('tr', text: /\A#{label}/)).to have_content(value)
end

Then(/^I should see "([^"]*)" in panel "([^"]*)" set to "([^"]*)"$/) do |label, panel, value|
  expect(find('.panel', text: panel).find('tr', text: label)).to have_content(value)
end

And(/^I fill in "([^"]*)" in panel "([^"]*)" with "([^"]*)"$/) do |field, panel, value|
  find('fieldset', text: panel).fill_in field, with: value
end

Given(/^I select "([^"]*)" from the drop down box for "([^"]*)" in panel "([^"]*)"$/) do |choice, name, panel|
  find('fieldset', text: panel).select(choice, from: name)
end