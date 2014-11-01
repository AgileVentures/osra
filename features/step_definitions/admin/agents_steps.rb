Given(/^the following agents exist:$/) do |table|
  table.hashes.each do |hash|
    Agent.create!(hash)
  end
end

Then(/^I should see "([^"]*)" linking to the (.*) index page$/) do |link_text, link_path|
  path = "admin_#{link_path.gsub(' ', '_')}_path"
  expect(page).to have_link(link_text, href: eval(path))
end

Then /^I should be on the "([^"]*)" page for agent "([^"]*)"$/ do |page_name, agent_name|
  agent = Agent.find_by_first_name agent_name
  expect(current_path).to eq path_to_admin_role(page_name, agent.id)
end

When(/^I (?:go to|am on) the "([^"]*)" page for agent "([^"]*)"$/) do |page, first_name|
  agent = Agent.find_by_first_name first_name
  visit path_to_admin_role(page, agent.id)
end
