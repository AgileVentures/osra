Given(/^the following sponsors exist:$/) do |table|
  table = table.transpose
  table.hashes.each do |hash|
    sponsor_type = SponsorType.find_by_name(hash[:sponsor_type])
    
    unless hash[:branch].blank?
      branch = Branch.find_by_name(hash[:branch]) ||
          FactoryGirl.create(:branch, name: hash[:branch])
    end

    unless hash[:organization].blank?
      organization = Organization.find_by_name(hash[:organization]) ||
          FactoryGirl.create(:organization, name: hash[:organization])
    end
    
    status= Status.find_by_name(hash[:status])
    
    sponsor = Sponsor.new(name: hash[:name], country: hash[:country],
                          gender: hash[:gender], sponsor_type: sponsor_type,
                          requested_orphan_count: hash[:requested_orphan_count],
                          address: hash[:address], email: hash[:email],
                          contact1: hash[:contact1], contact2: hash[:contact2],
                          additional_info: hash[:additional_info], branch: branch,
                          organization: organization,
                          start_date: hash[:start_date], status: status)
    sponsor.save!
  end
end

When(/^I (?:go to|am on) the "([^"]*)" page for sponsor "([^"]*)"$/) do |page, sponsor_name|
  sponsor = Sponsor.find_by name: sponsor_name
  visit path_to_admin_role(page, sponsor.id)
end

Then(/^I should be on the "(.*?)" page for sponsor "(.*?)"$/) do |page_name, sponsor_name|
  sponsor = Sponsor.find_by name: sponsor_name
  expect(current_path).to eq path_to_admin_role(page_name, sponsor.id)
end

Given /^sponsor "([^"]*)" is assigned to agent "([^"]*)"$/ do |sponsor, agent|
  sponsor = Sponsor.find_by_name(sponsor)
  agent = Agent.find_by_agent_name(agent) || FactoryGirl.create(:agent, agent_name: agent)
  sponsor.update!(agent: agent)
end

Then /^I should see "([^"]*)" linking to the "([^"]*)" page for (agent|sponsor|orphan|partner) "([^"]*)"$/ do |link, view, model, name|
  object_class = model.classify.constantize
  if object_class == Agent
    object_id = Agent.find_by_agent_name(name).id
  else
    object_id = object_class.find_by_name(name).id
  end

  object_class_param = object_class.name.parameterize
  case view
    when 'Show' then
      href = "admin_#{object_class_param}_path(#{object_id})"
    when 'Edit' then
      href = "edit_admin_#{object_class_param}_path(#{object_id})"
    when 'New' then
      href = "new_admin_#{object_class_param}_path"
    else
      raise "The view '#{view}' is not registered. See the step definition in #{__FILE__}"
  end

  expect(page).to have_link(link, href: eval(href))
end
