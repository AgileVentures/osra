World Helpers

Given(/^I am a new, authenticated user$/) do
  create_admin_user
  login
end

Given(/^I am an unauthenticated user$/) do
  logout
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
