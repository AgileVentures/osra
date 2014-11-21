Given(/^the following organizations exist:$/) do |table|
  table.hashes.each do |hash|
    Organization.create!(hash)
  end
end

When(/^I (?:go to|am on) the "([^"]*)" page for organization "([^"]*)"$/) do |page, org_name|
  org = Organization.find_by name: org_name
  visit path_to_admin_role(page, org.id)
end

When(/^I fill in new organization form:$/) do |table|
  table.rows.each do |row|
    fill_in row[0], with: row[1]
  end
end
Then(/^I should be on the "(.*?)" page for organization "(.*?)"$/) do |page, org_name|
  org = Organization.find_by name: org_name
  expect(current_path).to eq path_to_admin_role(page, org.id)
end

Then(/^I should not see "Organizations" linking to the admin organizations page$/) do
  expect(page).to_not have_link("Organizations", href: "#{admin_organizations_path}")
end

