Given(/^the following agents exist:$/) do |table|
  table.hashes.each do |hash|
    Agent.create!(hash)
  end
end

Then(/^I should see "([^"]*)" linking to the admin (.*) index page$/) do |link_text, link_path|
  path = "admin_#{link_path.gsub(' ', '_')}_path"
  expect(page).to have_link(link_text, href: eval(path))
end

Then /^I should be on the "([^"]*)" page for agent "([^"]*)"$/ do |page, agent|
  agent = Agent.find_by_agent_name agent
  expect(current_path).to eq path_to_admin_role(page, agent.id)
end

When(/^I (?:go to|am on) the "([^"]*)" page for agent "([^"]*)"$/) do |page, agent|
  agent = Agent.find_by_agent_name agent
  visit path_to_admin_role(page, agent.id)
end
